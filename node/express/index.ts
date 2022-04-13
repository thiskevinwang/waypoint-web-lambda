import { createApp } from './app'

const app = createApp()

app.listen(8080, () => {
  console.log('Listening on port 8080')
})
