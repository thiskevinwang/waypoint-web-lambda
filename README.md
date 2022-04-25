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
