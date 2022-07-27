IMAGE_NAME=go-gin
IMAGE_TAG=latest
PORT=8080
DEV_CMD?=go run .
WP_CMD?="$$GOPATH/bin/waypoint"

.PHONY: dev
dev:
	@echo " => Running $(IMAGE_NAME) in development mode"
	@$(DEV_CMD)

.PHONY: build
build:
	@echo " => Building $(IMAGE_NAME):$(IMAGE_TAG)"
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

.PHONY: run
run:
	@echo " => Running $(IMAGE_NAME):$(IMAGE_TAG) on PORT $(PORT)"
	docker run --rm -it --tty -e PORT=$(PORT) -p $(PORT):$(PORT) $(IMAGE_NAME):$(IMAGE_TAG)

.PHONY: init
init:
	@echo " => Initializing $(IMAGE_NAME)"
	@$(WP_CMD) init

.PHONY: up

# Makefile needs extra `$` for cmd interpolation
up:
	@echo " => Deploying $(IMAGE_NAME)"
	$(WP_CMD) up \
		-local=true \
  		-var DB_HOST=$$(terraform -chdir=terraform output db_host | jq -r) \
        -var DB_USER=$$(terraform -chdir=terraform output db_user | jq -r) \
        -var DB_PASSWORD=$$(terraform -chdir=terraform output db_password | jq -r) \
        -var DB_PORT=$$(terraform -chdir=terraform output db_port | jq -r)

.PHONY: get-url
get-url:
	@$(WP_CMD) release list -json | jq -r '.[0] | [.application.project,.application.application,.url] | join(" | ")'