.PHONY: help server build clean deploy

help:
	@echo "  make server  - dev server at http://localhost:1314"
	@echo "  make build   - production build into public/"
	@echo "  make deploy  - push master and wait for the Pages workflow"
	@echo "  make clean   - remove build artifacts"

server:
	hugo server --bind 127.0.0.1 --port 1314 --buildDrafts --disableFastRender \
		--baseURL="http://localhost:1314/"

build:
	hugo --minify --cleanDestinationDir --gc

clean:
	rm -rf public resources .hugo_build.lock

deploy:
	@if [ -n "$$(git status --porcelain)" ]; then echo "uncommitted changes — commit first"; exit 1; fi
	@git push origin master
	@gh workflow run publish.yaml --ref master
	@echo "workflow triggered; watch: https://github.com/iphysresearch/hewang-group/actions"
