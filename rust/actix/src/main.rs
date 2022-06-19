use actix_web::{get, http::header, post, web, App, HttpResponse, HttpServer, Responder};

#[get("/")]
async fn hello() -> impl Responder {
    HttpResponse::Ok()
        .insert_header(header::ContentType(mime::TEXT_HTML_UTF_8))
        .body(
            r#"
    <html>
        <head>
            <title>Hello from Rust + Actix ⚙️!</title>
            <meta name="color-scheme" content="light dark">
        </head>
        <body>
            <h3>Hello from Rust + Actix ⚙️!</h3>
            <p>Visit <a href="/hey">/hey</a></p>
        </body>
    </html>"#,
        )
}

#[post("/echo")]
async fn echo(req_body: String) -> impl Responder {
    HttpResponse::Ok().body(req_body)
}

async fn manual_hello() -> impl Responder {
    HttpResponse::Ok().body("Hey there!")
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let port = std::env::var("PORT")
        .unwrap_or_else(|_| "8080".to_string())
        .parse::<u16>()
        .unwrap();
    println!("Starting server at http://localhost:{}", port);
    HttpServer::new(|| {
        App::new()
            .service(hello)
            .service(echo)
            .route("/hey", web::get().to(manual_hello))
    })
    .bind(("localhost", port))?
    .run()
    .await
}
