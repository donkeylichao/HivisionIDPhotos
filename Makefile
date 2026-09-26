VERSION ?= dev
REGISTRY ?= registry.cn-beijing.aliyuncs.com
IMAGE_REPOSITORY ?= younger833/hivision_idphotos
IMAGE := $(REGISTRY)/$(IMAGE_REPOSITORY):$(VERSION)
DOCKER_PLATFORM ?= linux/amd64,linux/arm64
DOCKER_BUILD = docker buildx build --provenance=false --platform $(DOCKER_PLATFORM) -t $(IMAGE)
HELM_RELEASE ?= photos
KUBE_NAMESPACE ?= default
CHART ?= deployments/photos
HELM ?= helm

.PHONY: build docker-build docker-push deploy

build: docker-build

docker-build:
	$(DOCKER_BUILD) .

docker-push:
	$(DOCKER_BUILD) --push .

deploy:
	$(HELM) upgrade --install $(HELM_RELEASE) $(CHART) --namespace $(KUBE_NAMESPACE) --create-namespace --set-string image=$(IMAGE) --atomic --wait
