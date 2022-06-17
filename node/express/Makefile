API_IMAGE_NAME="node-express:latest"
API_CONTAINER_NAME="express-api"

DB_IMAGE_NAME="postgres"
DB_CONTAINER_NAME="some-postgres"
DB_PASSWORD="postgres"

# a dynamic ip address of the database container
DB_IP=$$(docker inspect $(DB_CONTAINER_NAME) | jq -r '.[].NetworkSettings.IPAddress')

# 'bridge' is a built-in docker network
NETWORK_NAME=bridge

# start the database and api without docker compose
all: db api
api:
	@docker build -t $(API_IMAGE_NAME) .
	@docker run \
		--name $(API_CONTAINER_NAME) \
		-p 3005:3005 \
		--rm \
		--tty \
		-e POSTGRES_USER=postgres \
		-e POSTGRES_PASSWORD=$(DB_PASSWORD) \
		-e POSTGRES_DB=test \
		-e POSTGRES_PORT=5432 \
		-e POSTGRES_HOST=$(DB_IP) \
		-e PORT=3005 \
		$(API_IMAGE_NAME)

db:
	@docker run \
		--name $(DB_CONTAINER_NAME) \
		-p 5432:5432 \
		-e POSTGRES_USER=postgres \
		-e POSTGRES_PASSWORD=$(DB_PASSWORD) \
		-e POSTGRES_DB=postgres \
		--rm \
		-d \
		$(DB_IMAGE_NAME)

# tear down the database and api
clean:
	@docker rm -f $(DB_CONTAINER_NAME)
	@docker rm -f $(API_CONTAINER_NAME)
db-ip:
	@echo $(DB_IP)
inspect:
	@docker network inspect $(NETWORK_NAME) | jq -C '.[].Containers'
watch:
	@watch --color -n 3 "make inspect"

# docker compose
up:
	@docker compose build
	@docker compose up

down:
	@docker compose down

branch-to-db:
	$(eval orig := $(shell git branch --show-current))
	@echo ${orig}
	@echo $${orig//[^a-zA-Z0-9\s:]/_}

deploy:
	@$$GOPATH/bin/waypoint up -prune-retain=100 -var tag=git-1