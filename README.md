![hero](https://user-images.githubusercontent.com/26389321/168480028-c71d6450-261d-4880-986b-e8e209926563.png)

# waypoint-web-lambda

This is a working collection of basic web-server-in-aws-lambda setups, in various languages using various popular web frameworks.

The images built from the associated `Dockerfiles` can be uploadeded to ECR, and then used by Lambda.

You can ignore the `waypoint.hcl` files unless you want to use [waypoint](https://www.waypointproject.io/downloads)
to handle the entire build & deployment process.

## Prerequisites

> **Note**: In order to run all [`Makefile`] commands, the following dependencies
> will need to be installed. Though, not all are needed if you’re only running a
> subset of all the available languages.

[`Makefile`]: ./Makefile

- `docker` CLI & Docker Desktop
- [`waypoint`](https://www.waypointproject.io/downloads) CLI + a running Server
- AWS Credentials
- `deno`
- `go`
- `node` + `npm`
- `python3`
- `cargo`
- `swift`
- [`vapor`](https://docs.vapor.codes/install/macos/) CLI

## Apps

There a various `Make` commands available in the [`Makefile`] to
run each app with their native build tool and with docker, and to deploy them
to AWS Lambda.

## Deployed Examples

> **Warning**: These URLs may change at any time.

| Language | Framework  | Lambda URL                                                           |
| :------- | :--------- | :------------------------------------------------------------------- |
| Deno     | Oak        | https://kafr7v6452ywy4ien6rh7xyvcq0zpdsk.lambda-url.us-east-1.on.aws |
| Go       | Gin        | https://qvomz3om452pulf5joiuyojwc40ekond.lambda-url.us-east-1.on.aws |
| Node     | Next.js    | https://6f75ux4u5be7x2n6qip7ftn5t40mkhzh.lambda-url.us-east-1.on.aws |
| Node     | Express.js | https://h6hgqeiofnuk4rsk44a2kigo4i0ewjfn.lambda-url.us-east-1.on.aws |
| Python   | FastAPI    | https://6tgotnpviamif7ahs54gieskqy0hehao.lambda-url.us-east-1.on.aws |
| Python   | Flask      | https://vfxxckern6sxk4gd7mjunj4zoi0lcwwd.lambda-url.us-east-1.on.aws |
| Rust     | Rocket     | https://ofsktryxlax4xf7vnzno4425lq0bqsej.lambda-url.us-east-1.on.aws |
| Rust     | Actix      | https://qlkeo2h74asvqbznraayrzxd4q0yfgth.lambda-url.us-east-1.on.aws |
| Swift    | Vapor      | https://jsupnxhiyrtnu66zbke3wvoe5q0lywjo.lambda-url.us-east-1.on.aws |
