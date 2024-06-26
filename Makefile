COMMAND ?= `grep 'web' Procfile | cut -d ':' -f2`
RUBY_VERSION ?= `cat .ruby-version`
REVISION ?= `git rev-parse HEAD`

.PHONY: build_docker_image run

build_docker_image:
	DOCKER_BUILDKIT=1 docker build \
	  --build-arg REVISION=$(REVISION) \
	  --build-arg RUBY_VERSION=$(RUBY_VERSION) \
	  --progress=plain \
	  -t pipeline .

run: build_docker_image
	docker run -p 20465:20465 --env-file .env -it pipeline $(COMMAND)
