
.DEFAULT_GOAL := default

default:
	@echo "Run one of:"
	@echo "- make nodejs-app"
	@echo "- make go-app"

nodejs-app:
	@$(MAKE) -C node/express

go-app:
	@$(MAKE) -C go/gin