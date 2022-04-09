IMAGE_TAG=go-gin:latest

PORT=8080
PLATFORM=linux/arm64

docker:

	@docker buildx build --platform=${PLATFORM} -t ${IMAGE_TAG} .
	@echo ""

	@echo "------------------------------------------"
	@echo "Image architecture: $$(docker inspect ${IMAGE_TAG} | jq -r '.[].Architecture')"
	@echo "------------------------------------------"

	@echo "Test the image with:"

	@echo "docker run --rm --tty -p ${PORT}:${PORT} ${IMAGE_TAG}"

waypoint:
	@echo "..."
	@waypoint init