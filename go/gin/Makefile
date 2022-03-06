IMAGE=eks-go-gin
TAG=latest
PORT=8080

docker:
	@echo "Building Docker image"

	@docker buildx build --platform=linux/arm64 -t ${IMAGE}:${TAG} .
	@echo ""

	@echo "Image architecture: $$(docker inspect ${IMAGE}:${TAG} | jq -r '.[].Architecture')"
	@echo "Test the image with:"

	@echo "\tdocker run -p ${8080}:${8080} ${IMAGE}:${TAG}${NC}"

waypoint:
	@echo "..."
	@waypoint init