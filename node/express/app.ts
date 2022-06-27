import express from 'express'
import bodyParser from 'body-parser'
import type { RequestHandler, ErrorRequestHandler } from 'express'
import morgan from 'morgan'

import tf from '@tensorflow/tfjs-node'
import * as toxicity from '@tensorflow-models/toxicity'

import * as fs from 'node:fs/promises'
import crypto from 'node:crypto'

let model: toxicity.ToxicityClassifier

export const createApp = () => {
  const app = express()
  app.use(morgan('short'))
  app.use(bodyParser.json())

  app.use('/toxicity', async (req, res) => {
    const message = (req.body.message || req.query.message) as string

    if (!message) {
      return res.status(400).json({ message: 'Invalid message' })
    }
    if (message.length > 256) {
      return res.status(400).json({ message: 'Message too long' })
    }

    let now = performance.now()
    const hash = crypto.createHash('md5').update(message, 'utf8').digest('hex')
    res.header('X-Hash-Time', `${performance.now() - now}ms`)

    try {
      const cache = await fs.readFile(`/tmp/${hash}.json`, {
        encoding: 'utf8',
      })
      res.header('X-Prediction-Cached', `1`)
      return res.json(JSON.parse(cache))
    } catch (e) {
      console.warn(e)
    }

    console.log({ message, hash })

    now = performance.now()
    if (!model) {
      model = await toxicity.load(0.7, [])
    }
    res.setHeader('X-Model-Load-Time', `${performance.now() - now}ms`)

    now = performance.now()
    const predictions = await model.classify(message)
    res.setHeader('X-Toxicity-Time', `${performance.now() - now}ms`)

    const result = predictions.reduce((acc, { label, results }) => {
      acc[label] = results[0]?.match
      return acc
    }, {} as { [label: string]: boolean })

    await fs.mkdir(`/tmp`, { recursive: true }).catch(console.error)
    await fs
      .writeFile(
        `/tmp/${hash}.json`,
        JSON.stringify({ message, hash, ...result }, null, 2),
        {
          flag: 'w',
        }
      )
      .catch(console.error)

    return res.json(result)
  })

  app.get('/', (req, res) => {
    res
      .status(200)
      .type('html')
      .send(
        `<!DOCTYPE html>
<html>
  <head>
    <title>Hello from Node + Express 🍔!</title>
    <meta name="color-scheme" content="light dark">
  </head>
  <body>
    <h3>Hello from Node + Express 🍔!</h3>
  </body>
</html>
      `
      )
  })

  // default 404 handler
  app.use((req, res, next) => {
    res.status(404).send('Not found')
  })

  // default 500
  app.use(((err, req, res, next) => {
    console.error(err.stack)
    res.status(500).send('Borked')
  }) as ErrorRequestHandler)

  return app
}
