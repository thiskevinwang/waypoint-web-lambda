IMAGE=eks-nodejs-express
TAG=latest
PORT=3000

docker:
	@echo "Building Docker image"

	@docker buildx build --platform=linux/arm64 -t ${IMAGE}:${TAG} .
	@echo ""

	@echo "Image architecture: $$(docker inspect ${IMAGE}:${TAG} | jq -r '.[].Architecture')"
	@echo "Test the image with:"

	@echo "\tdocker run -p ${PORT}:${PORT} ${IMAGE}:${TAG}${NC}"