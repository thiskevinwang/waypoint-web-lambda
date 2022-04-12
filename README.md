# waypoint-web-lambda

This is a working collection of basic web-server-in-aws-lambda setups, in various languages using various popular web frameworks.

This requires [waypoint](https://www.waypointproject.io/downloads)

## Apps

Deploy either of the webserver apps with:

```
# from ./go/gin or ./nodejs/express or ./rust/actix

waypoint install -platform=kubernetes -accept-tos
# or
waypoint install -platform=docker -accept-tos

waypoint init
waypoint up
```
