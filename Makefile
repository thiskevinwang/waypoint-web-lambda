
.DEFAULT_GOAL := list

# https://stackoverflow.com/a/26339924/9823455
.PHONY: list
list:
	@tput setaf 3
	@echo "Please specify a make-target:"
	@tput sgr0
	@LC_ALL=C $(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

.PHONY: build-all
build-all: build-deno/oak build-go/gin \
	build-node/express build-node/next \
	build-python/flask build-python/fastapi \
	build-rust/actix build-rust/rocket \
	build-swift/vapor-app

.PHONY: init-all
init-all: init-deno/oak init-go/gin \
	init-node/express init-node/next \
	init-python/flask init-python/fastapi \
	init-rust/actix init-rust/rocket \
	init-swift/vapor-app

.PHONY: up-all
up-all: up-deno/oak up-go/gin \
	up-node/express up-node/next \
	up-python/flask up-python/fastapi \
	up-rust/actix up-rust/rocket \
	up-swift/vapor-app

.PHONY: get-url-all
get-url-all: get-url-deno/oak get-url-go/gin \
	get-url-node/express get-url-node/next \
	get-url-python/flask get-url-python/fastapi \
	get-url-rust/actix get-url-rust/rocket \
	get-url-swift/vapor-app

.PHONY: dev-deno/oak build-deno/oak run-deno/oak init-deno/oak up-deno/oak get-url-deno/oak
dev-deno/oak:
	@$(MAKE) -C deno/oak dev
build-deno/oak:
	@$(MAKE) -C deno/oak build
run-deno/oak:
	@$(MAKE) -C deno/oak run
init-deno/oak:
	@$(MAKE) -C deno/oak init
up-deno/oak:
	@$(MAKE) -C deno/oak up
get-url-deno/oak:
	@$(MAKE) -C deno/oak get-url

.PHONY: dev-go/gin build-go/gin run-go/gin init-go/gin up-go/gin get-url-go/gin
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
get-url-go/gin:
	@$(MAKE) -C go/gin get-url

.PHONY: dev-node/express build-node/express run-node/express init-node/express up-node/express get-url-node/express
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
get-url-node/express:
	@$(MAKE) -C node/express get-url

.PHONY: dev-node/next build-node/next run-node/next init-node/next up-node/next get-url-node/next
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
get-url-node/next:
	@$(MAKE) -C node/next get-url

.PHONY: dev-python/fastapi build-python/fastapi run-python/fastapi init-python/fastapi up-python/fastapi get-url-python/fastapi
dev-python/fastapi:
	@$(MAKE) -C python/fastapi dev
build-python/fastapi:
	@$(MAKE) -C python/fastapi build
run-python/fastapi:
	@$(MAKE) -C python/fastapi run
init-python/fastapi:
	@$(MAKE) -C python/fastapi init
up-python/fastapi:
	@$(MAKE) -C python/fastapi up
get-url-python/fastapi:
	@$(MAKE) -C python/fastapi get-url

.PHONY: dev-python/flask build-python/flask run-python/flask init-python/flask up-python/flask get-url-python/flask
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
get-url-python/flask:
	@$(MAKE) -C python/flask get-url

.PHONY: dev-rust/actix build-rust/actix run-rust/actix init-rust/actix up-rust/actix get-url-rust/actix
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
get-url-rust/actix:
	@$(MAKE) -C rust/actix get-url

.PHONY: dev-rust/rocket build-rust/rocket run-rust/rocket init-rust/rocket up-rust/rocket get-url-rust/rocket
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
get-url-rust/rocket:
	@$(MAKE) -C rust/rocket get-url

.PHONY: dev-swift/vapor-app build-swift/vapor-app run-swift/vapor-app init-swift/vapor-app up-swift/vapor-app get-url-swift/vapor-app
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
get-url-swift/vapor-app:
	@$(MAKE) -C swift/vapor-app get-url


# SERVER_IMAGE=ghcr.io/hashicorp/waypoint/alpha:02952e297
# ODR_IMAGE=ghcr.io/hashicorp/waypoint/alpha-odr:02952e297

SERVER_IMAGE=ghcr.io/hashicorp/waypoint/alpha:latest
ODR_IMAGE=ghcr.io/hashicorp/waypoint/alpha-odr:latest

# SERVER_IMAGE=hashicorp/waypoint:latest
# ODR_IMAGE=hashicorp/waypoint-odr:latest

# SERVER_IMAGE=ghcr.io/thiskevinwang/waypoint:latest
# ODR_IMAGE=ghcr.io/thiskevinwang/waypoint-odr:latest


.PHONY: reset-k8s
reset-k8s:
	kubectl delete sts waypoint-server
	kubectl delete pvc data-waypoint-server-0
	kubectl delete svc waypoint
	kubectl delete deploy waypoint-runner

.PHONY: install-k8s
install-k8s:
	waypoint server install \
		-accept-tos \
		-platform=kubernetes \
		-k8s-server-image=$(SERVER_IMAGE) \
		-k8s-odr-image=$(ODR_IMAGE)

.PHONY: reset-docker
reset-docker:
	docker stop waypoint-server
	docker rm waypoint-server
	docker volume prune -f

.PHONY: install-docker
install-docker:
	waypoint server install \
		-accept-tos \
		-platform=docker \
		-docker-server-image=$(SERVER_IMAGE) \
		-docker-odr-image=$(ODR_IMAGE)

.PHONY: install-docker-runner
install-docker-runner:
	waypoint runner install


.PHONY: upgrade
upgrade:
	waypoint server upgrade \
		-auto-approve \
		-k8s-server-image=$(SERVER_IMAGE) \
		-k8s-odr-image=$(ODR_IMAGE)

# For remote runners to auth w/ AWS
.PHONY: runner-config
runner-config:
	waypoint config set -runner \
		AWS_ACCESS_KEY_ID=FIXME \
		AWS_SECRET_ACCESS_KEY=FIXME \
		AWS_REGION=FIXME