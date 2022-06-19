import express from 'express'
import type { RequestHandler, ErrorRequestHandler } from 'express'
import morgan from 'morgan'

export const createApp = () => {
  const app = express()

  app.use(morgan('short'))

  app.get('/', (req, res) => {
    res
      .status(200)
      .type('html')
      .send(
        `<!DOCTYPE html>
<html>
  <head>
    <title>Hello from Express 🍔!</title>
    <meta name="color-scheme" content="light dark">
  </head>
  <body>
    <h3>Hello from Express 🍔!</h3>
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
