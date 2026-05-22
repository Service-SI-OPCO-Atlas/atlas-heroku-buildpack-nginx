.PHONY: build build-heroku-22 build-heroku-24 build-heroku-26 build-heroku-XXXX shell

HEROKU_STACK_VERSION ?=

build: build-heroku-22 build-heroku-24 build-heroku-26

build-heroku-22:
	@echo "Building nginx in Docker for heroku-22..."
	@docker run -v $(shell pwd):/buildpack --rm -it -e "STACK=heroku-22" -w /buildpack --platform linux/amd64 heroku/heroku:22-build scripts/build_nginx /buildpack/nginx-heroku-22.tgz

build-heroku-24:
	@echo "Building nginx in Docker for heroku-24 (amd64)..."
	@docker run -v $(shell pwd):/buildpack --rm -it -e "STACK=heroku-24" -w /buildpack --platform linux/amd64 heroku/heroku:24-build scripts/build_nginx /buildpack/nginx-heroku-24-amd64.tgz
	@echo "Building nginx in Docker for heroku-24 (arm64)..."
	@docker run -v $(shell pwd):/buildpack --rm -it -e "STACK=heroku-24" -w /buildpack --platform linux/arm64 heroku/heroku:24-build scripts/build_nginx /buildpack/nginx-heroku-24-arm64.tgz

build-heroku-26:
	@echo "Building nginx in Docker for heroku-26 (amd64)..."
	@docker run -v $(shell pwd):/buildpack --rm -it -e "STACK=heroku-26" -w /buildpack --platform linux/amd64 heroku/heroku:26-build scripts/build_nginx /buildpack/nginx-heroku-26-amd64.tgz
	@echo "Building nginx in Docker for heroku-26 (arm64)..."
	@docker run -v $(shell pwd):/buildpack --rm -it -e "STACK=heroku-26" -w /buildpack --platform linux/arm64 heroku/heroku:26-build scripts/build_nginx /buildpack/nginx-heroku-26-arm64.tgz

shell:
	@echo "Opening heroku-26 shell..."
	@docker run -v $(shell pwd):/buildpack --rm -it -e "STACK=heroku-26" -e "PORT=5000" -w /buildpack heroku/heroku:26-build bash

build-heroku-XXXX:
	@if [ -z "$(HEROKU_STACK_VERSION)" ]; then \
		echo "HEROKU_STACK_VERSION is required."; \
		echo "Usage: HEROKU_STACK_VERSION=26 make build-heroku-XXXX"; \
		exit 1; \
	fi
	@echo "Building nginx in Docker for heroku-$(HEROKU_STACK_VERSION) (amd64)..."
	@docker run -v $(shell pwd):/buildpack --rm -it -e "STACK=heroku-$(HEROKU_STACK_VERSION)" -w /buildpack --platform linux/amd64 heroku/heroku:$(HEROKU_STACK_VERSION)-build scripts/build_nginx /buildpack/nginx-heroku-$(HEROKU_STACK_VERSION)-amd64.tgz
	@if [ "$(HEROKU_STACK_VERSION)" != "22" ]; then \
		echo "Building nginx in Docker for heroku-$(HEROKU_STACK_VERSION) (arm64)..."; \
		docker run -v $(shell pwd):/buildpack --rm -it -e "STACK=heroku-$(HEROKU_STACK_VERSION)" -w /buildpack --platform linux/arm64 heroku/heroku:$(HEROKU_STACK_VERSION)-build scripts/build_nginx /buildpack/nginx-heroku-$(HEROKU_STACK_VERSION)-arm64.tgz; \
	fi
