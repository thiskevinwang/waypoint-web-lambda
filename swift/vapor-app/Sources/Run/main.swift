import App
import Vapor

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)
let app = Application(env)

let port = Environment.get("PORT") ?? "8080"
app.http.server.configuration.port = Int(port)!

defer { app.shutdown() }
try configure(app)
try app.run()
