import Vapor

func routes(_ app: Application) throws {
    app.get { req in
         return Response(
            status: .ok, 
            headers: ["Content-Type": "text/html; charset=utf-8"], 
            body: """
    <html>
        <head>
            <title>Hello from Vapor 💨!</title>
            <meta name="color-scheme" content="light dark">
        </head>
        <body>
            <h3>Hello from Vapor 💨!</h3>
            <p>Visit <a href="/hello">/hello</a></p>
        </body>
    </html>
""")
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }
}
