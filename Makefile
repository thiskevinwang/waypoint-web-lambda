
.DEFAULT_GOAL := list

# https://stackoverflow.com/a/26339924/9823455
.PHONY: list
list:
	@tput setaf 3
	@echo "Please specify a make-target:"
	@tput sgr0
	@LC_ALL=C $(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

###########
# Node.js #
###########
nodejs-docker:
	@$(MAKE) -C node/express docker
nodejs-app:
	@$(MAKE) -C node/express waypoint

######
# GO #
######
go-docker:
	@$(MAKE) -C go/gin docker
go-app:
	@$(MAKE) -C go/gin waypoint