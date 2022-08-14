import express from 'express'
import type { Request, ErrorRequestHandler } from 'express'
import morgan from 'morgan'

import { pool } from './db/postgres'

interface Ctx {
  pool: typeof pool
}

declare global {
  namespace Express {
    interface Request {
      ctx: Ctx
    }
  }
}

export const createApp = () => {
  const app = express()

  app.use(morgan('short'))

  app.use(async (req, res, next) => {
    req.ctx = { pool }
    next()
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

  app.get('/db', async (req, res, next) => {
    try {
      const currentDb = await req.ctx.pool.query('SELECT current_database();')
      const dbs = await req.ctx.pool.query(`
      SELECT datname FROM pg_database
       WHERE datistemplate = false
         AND datname NOT SIMILAR TO '%(rdsadmin|postgres)%';
    `)
      const now = await req.ctx.pool.query('SELECT NOW() as now;')
      res.json({ ...now.rows[0], ...currentDb.rows[0], dbs: dbs.rows })
    } catch (e) {
      next(e)
    }
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
