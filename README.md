![hero](https://user-images.githubusercontent.com/26389321/168480028-c71d6450-261d-4880-986b-e8e209926563.png)


# waypoint-web-lambda

This is a working collection of basic web-server-in-aws-lambda setups, in various languages using various popular web frameworks.

The images built from the associated `Dockerfiles` can be uploadeded to ECR, and then used by Lambda.

You can ignore the `waypoint.hcl` files unless you want to use [waypoint](https://www.waypointproject.io/downloads)
to handle the entire build & deployment process.

## Apps

Only build the docker image for an app:

```bash
# example: from ./go/gin
docker build -t go-gin:latest .

# test it
docker run --rm --tty -p 7531:7531 go-gin:latest
```

Deploy either of the webserver apps with `waypoint`:

```bash
# from ./go/gin or ./nodejs/express or ./rust/actix

waypoint install -platform=kubernetes -accept-tos
# or
waypoint install -platform=docker -accept-tos

waypoint init
waypoint up
```

## Deployed Examples

(Subject to change...)

| Language  | Framework  | Lambda URL                                                           |
| :-------- | :--------- | :------------------------------------------------------------------- |
| 🟩 Node   | Next.js    | https://6f75ux4u5be7x2n6qip7ftn5t40mkhzh.lambda-url.us-east-1.on.aws |
| 🟩 Node   | Express.js | https://h6hgqeiofnuk4rsk44a2kigo4i0ewjfn.lambda-url.us-east-1.on.aws |
| 🐹 Go     | Gin        | https://qvomz3om452pulf5joiuyojwc40ekond.lambda-url.us-east-1.on.aws |
| 🐍 Python | Flask      | https://vfxxckern6sxk4gd7mjunj4zoi0lcwwd.lambda-url.us-east-1.on.aws |
| 🦀 Rust   | Rocket     | https://ehoa2uwpphfrg3pshhwgi7xihi0wbulb.lambda-url.us-east-1.on.aws |
| 🦀 Rust   | Actix      | https://qlkeo2h74asvqbznraayrzxd4q0yfgth.lambda-url.us-east-1.on.aws |
| 🕊 Swift   | Vapor      | https://jsupnxhiyrtnu66zbke3wvoe5q0lywjo.lambda-url.us-east-1.on.aws |
