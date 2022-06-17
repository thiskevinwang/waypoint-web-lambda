import express from 'express'
import type { ErrorRequestHandler } from 'express'
import morgan from 'morgan'

import { Pool } from 'pg'
import type { PoolConfig } from 'pg'

const config: PoolConfig = {
  user: process.env.POSTGRES_USER,
  password: process.env.POSTGRES_PASSWORD,
  database: process.env.POSTGRES_DB,
  port: Number(process.env.POSTGRES_PORT),
  host: process.env.POSTGRES_HOST,
  ssl:
    process.env.NODE === 'production'
      ? { rejectUnauthorized: false }
      : undefined,
}

declare global {
  namespace Express {
    interface Request {
      pool: Pool
    }
  }
}

export const createApp = () => {
  const app = express()

  app.use(morgan('short'))
  // assign the pool to the request object
  app.use((req, _, next) => {
    req.pool = new Pool(config)
    next()
  })

  app.get('/', (req, res) => {
    res.status(200).send('Hello from Node.js & Express!')
  })

  // Test integration with Postgres Database
  app.get('/health', async (req, res, next) => {
    try {
      const waitTime = Number(req.query.wait_time) || 3

      if (typeof waitTime !== 'number') {
        return res.status(400).send('Invalid wait_time')
      }
      if (waitTime > 10) {
        return res.status(400).send('wait_time too long')
      }

      const { rows } = await req.pool.query(`SELECT pg_sleep($1)`, [waitTime])
      return res.status(200).json(rows)
    } catch (err) {
      next(err)
    }
  })

  app.get('/current', async (req, res, next) => {
    try {
      const { rows } = await req.pool.query(`SELECT current_database()`)
      res.status(200).json(rows)
    } catch (err) {
      next(err)
    }
  })

  // default 404 handler
  app.use((_, res, next) => {
    res.status(404).send('Not found')
  })

  // default 500
  app.use(((err, _, res, __) => {
    console.error(err.stack)
    res.status(500).json({ message: err.message })
  }) as ErrorRequestHandler)

  return app
}
