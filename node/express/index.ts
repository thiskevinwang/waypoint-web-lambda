import { createApp } from './app'

const app = createApp()

const port = process.env.PORT || 8080
app.listen(port, () => {
  console.log(`Listening @ localhost:${port}`)
})
