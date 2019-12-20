MOD_PYTHON_VERSION = 3.5.0
BUILD = 1
VERSION = $(MOD_PYTHON_VERSION)-build$(BUILD)

PACKAGE = amazon2-mod-python
DOCKER_REGISTRY = caltechads

#======================================================================

version:
	@echo ${VERSION}

image_name:
	@echo ${DOCKER_REGISTRY}/${PACKAGE}:${VERSION}

force-build:
	docker build --no-cache -t earthworm:${VERSION} .
	docker tag ${PACKAGE}:${VERSION} earthworm:latest
	docker tag ${PACKAGE}:${VERSION} earthworm:${MOD_PYTHON_VERSION}
	docker image prune -f

build:
	docker build -t ${PACKAGE}:${VERSION} .
	docker tag ${PACKAGE}:${VERSION} ${PACKAGE}:latest
	docker tag ${PACKAGE}:${VERSION} ${PACKAGE}:${MOD_PYTHON_VERSION}
	docker image prune -f

tag:
	docker tag ${PACKAGE}:${VERSION} ${DOCKER_REGISTRY}/${PACKAGE}:${VERSION}
	docker tag ${PACKAGE}:latest ${DOCKER_REGISTRY}/${PACKAGE}:latest
	docker tag ${PACKAGE}:${MOD_PYTHON_VERSION} ${DOCKER_REGISTRY}/${PACKAGE}:${MOD_PYTHON_VERSION}

push: tag
	docker push ${DOCKER_REGISTRY}/${PACKAGE}:${MOD_PYTHON_VERSION}

dev:
	docker-compose up

docker-clean:
	docker stop $(shell docker ps -a -q)
	docker rm $(shell docker ps -a -q)
