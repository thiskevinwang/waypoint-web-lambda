image_name=rust-rocket
image_tag=latest
port=8080

.PHONY: build
build:
	@echo " => Building $(image_name):$(image_tag)"
	@docker build -t $(image_name):$(image_tag) .

.PHONY: run
run:
	@echo " => Running $(image_name):$(image_tag) on port $(port)"
	@docker run -e PORT=$(port) -p $(port):$(port) $(image_name):$(image_tag)
