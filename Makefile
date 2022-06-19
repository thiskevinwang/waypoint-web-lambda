
.DEFAULT_GOAL := list

# https://stackoverflow.com/a/26339924/9823455
.PHONY: list
list:
	@tput setaf 3
	@echo "Please specify a make-target:"
	@tput sgr0
	@LC_ALL=C $(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

.PHONY: build-all
build-all: build-deno-http build-go-gin \
	build-node-express build-node-next \
	build-python-flask \
	build-rust-actix build-rust-rocket \
	build-swift-vapor-app

.PHONY: build-deno-http run-deno-http
build-deno-http:
	@echo " => Building deno/http..."
	@$(MAKE) -C deno/http build

run-deno-http:
	@echo " => Running deno/http..."
	@$(MAKE) -C deno/http run

.PHONY: build-go-gin run-go-gin
build-go-gin:
	@echo " => Building go/gin..."
	@$(MAKE) -C go/gin build

run-go-gin:
	@echo " => Running go/gin..."
	@$(MAKE) -C go/gin run

.PHONY: build-node-express run-node-express
build-node-express:
	@echo " => Building node/express..."
	@$(MAKE) -C node/express build

run-node-express:
	@echo " => Running node/express..."
	@$(MAKE) -C node/express run

.PHONY: build-node-next run-node-next
build-node-next:
	@echo " => Building node/next..."
	@$(MAKE) -C node/next build

run-node-next:
	@echo " => Running node/next..."
	@$(MAKE) -C node/next run

.PHONY: build-python-flask run-python-flask
build-python-flask:
	@echo " => Building python/flask..."
	@$(MAKE) -C python/flask build

run-python-flask:
	@echo " => Running python/flask..."
	@$(MAKE) -C python/flask run

.PHONY: build-rust-actix run-rust-actix
build-rust-actix:
	@echo " => Building rust/actix..."
	@$(MAKE) -C rust/actix build

run-rust-actix:
	@echo " => Running rust/actix..."
	@$(MAKE) -C rust/actix run

.PHONY: build-rust-rocket run-rust-rocket
build-rust-rocket:
	@echo " => Building rust/rocket..."
	@$(MAKE) -C rust/rocket build

run-rust-rocket:
	@echo " => Running rust/rocket..."
	@$(MAKE) -C rust/rocket run

.PHONY: build-swift-vapor-app
build-swift-vapor-app:
	@echo " => Building swift/vapor-app..."
	@$(MAKE) -C swift/vapor-app build

run-swift-vapor-app:
	@echo " => Running swift/vapor-app..."
	@$(MAKE) -C swift/vapor-app run

