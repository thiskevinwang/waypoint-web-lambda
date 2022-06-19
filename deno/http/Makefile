IMAGE_NAME=deno-http
IMAGE_TAG=latest
PORT=8080
DEV_CMD?=deno run --allow-env --allow-read --allow-net  main.ts
WP_CMD?="$$GOPATH/bin/waypoint"

.PHONY: dev
dev:
	@echo " => Running $(IMAGE_NAME) in development mode"
	@$(DEV_CMD)

.PHONY: build
build:
	@echo " => Building $(IMAGE_NAME):$(IMAGE_TAG)"
	@docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

.PHONY: run
run:
	@echo " => Running $(IMAGE_NAME):$(IMAGE_TAG) on PORT $(PORT)"
	@docker run -it --tty -e PORT=$(PORT) -p $(PORT):$(PORT) $(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: init
init:
	@echo " => Initializing Waypoint project"
	@waypoint init

.PHONY: up
up:
	@echo " => Deploying Waypoint project"
	@$(WP_CMD) up -local=true

.PHONY: get-url
get-url:
	@$(WP_CMD) release list -json | jq -r '.[0] | [.application.project,.application.application,.url] | join(" | ")'