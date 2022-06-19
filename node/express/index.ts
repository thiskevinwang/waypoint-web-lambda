import { createApp } from './app'

const app = createApp()

const port = process.env.PORT || 8080

app.listen(port, () => {
  console.log(`🚀 Server is ready at: http://localhost:${port}`)
})
