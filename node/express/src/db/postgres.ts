import { config } from 'dotenv'
config()
import { Pool } from 'pg'

const db_name = (() => {
  let value = process.env.DB_DATABASE || 'postgres'
  //   replace - and / with _
  value = value.replace(/[-/]/g, '_')
  // trim "wp_" from the start
  value = value.replace(/^wp_/, '')
  // add "wp_" to the start
  value = `wp_${value}`
  return value
})()

export const pool = new Pool({
  max: 1,
  min: 0,
  idleTimeoutMillis: 120_000,
  connectionTimeoutMillis: 5_000,
  // - - - - -
  application_name: 'BOB',
  host: process.env.DB_HOST || '',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  port: parseInt(process.env.DB_PORT!) || 5432,
  database: db_name,
})
