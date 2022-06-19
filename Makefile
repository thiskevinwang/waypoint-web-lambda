
.DEFAULT_GOAL := list

# https://stackoverflow.com/a/26339924/9823455
.PHONY: list
list:
	@tput setaf 3
	@echo "Please specify a make-target:"
	@tput sgr0
	@LC_ALL=C $(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

.PHONY: build-all
build-all: build-deno/http build-go/gin \
	build-node/express build-node/next \
	build-python/flask \
	build-rust/actix build-rust/rocket \
	build-swift/vapor-app

.PHONY: init-all
init-all: init-deno/http init-go/gin \
	init-node/express init-node/next \
	init-python/flask \
	init-rust/actix init-rust/rocket \
	init-swift/vapor-app

.PHONY: up-all
up-all: up-deno/http up-go/gin \
	up-node/express up-node/next \
	up-python/flask \
	up-rust/actix up-rust/rocket \
	up-swift/vapor-app


.PHONY: dev-deno/http build-deno/http run-deno/http init-deno/http up-deno/http
dev-deno/http:
	@$(MAKE) -C deno/http dev
build-deno/http:
	@$(MAKE) -C deno/http build
run-deno/http:
	@$(MAKE) -C deno/http run
init-deno/http:
	@$(MAKE) -C deno/http init
up-deno/http:
	@$(MAKE) -C deno/http up

dev-go/gin:
	@$(MAKE) -C go/gin dev
build-go/gin:
	@$(MAKE) -C go/gin build
run-go/gin:
	@$(MAKE) -C go/gin run
init-go/gin:
	@$(MAKE) -C go/gin init
up-go/gin:
	@$(MAKE) -C go/gin up

dev-node/express:
	@$(MAKE) -C node/express dev
build-node/express:
	@$(MAKE) -C node/express build
run-node/express:
	@$(MAKE) -C node/express run
init-node/express:
	@$(MAKE) -C node/express init
up-node/express:
	@$(MAKE) -C node/express up

dev-node/next:
	@$(MAKE) -C node/next dev
build-node/next:
	@$(MAKE) -C node/next build
run-node/next:
	@$(MAKE) -C node/next run
init-node/next:
	@$(MAKE) -C node/next init
up-node/next:
	@$(MAKE) -C node/next up

dev-python/flask:
	@$(MAKE) -C python/flask dev
build-python/flask:
	@$(MAKE) -C python/flask build
run-python/flask:
	@$(MAKE) -C python/flask run
init-python/flask:
	@$(MAKE) -C python/flask init
up-python/flask:
	@$(MAKE) -C python/flask up

dev-rust/actix:
	@$(MAKE) -C rust/actix dev
build-rust/actix:
	@$(MAKE) -C rust/actix build
run-rust/actix:
	@$(MAKE) -C rust/actix run
init-rust/actix:
	@$(MAKE) -C rust/actix init
up-rust/actix:
	@$(MAKE) -C rust/actix up

dev-rust/rocket:
	@$(MAKE) -C rust/rocket dev
build-rust/rocket:
	@$(MAKE) -C rust/rocket build
run-rust/rocket:
	@$(MAKE) -C rust/rocket run
init-rust/rocket:
	@$(MAKE) -C rust/rocket init
up-rust/rocket:
	@$(MAKE) -C rust/rocket up

dev-swift/vapor-app:
	@$(MAKE) -C swift/vapor-app dev
build-swift/vapor-app:
	@$(MAKE) -C swift/vapor-app build
run-swift/vapor-app:
	@$(MAKE) -C swift/vapor-app run
init-swift/vapor-app:
	@$(MAKE) -C swift/vapor-app init
up-swift/vapor-app:
	@$(MAKE) -C swift/vapor-app up
	