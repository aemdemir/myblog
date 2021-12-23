#
# Helpers
#

## help: prints this help message
.PHONY: help
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'

.PHONY: confirm
confirm:
	@echo -n 'Are you sure? [y/N] ' && read ans && [ $${ans:-N} = y ]

#
# Development
#

## run: runs the server
.PHONY: run
run:
	hugo server -D

## posts/new name=$1: creates a new post
.PHONY: posts/new
posts/new:
	@echo 'Creating a new post ${name}...'
	hugo new --kind post posts/${name}