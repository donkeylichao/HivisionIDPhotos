VERSION ?= dev
ARCH ?= arm64
REGISTRY ?= registry.cn-beijing.aliyuncs.com
IMAGE_REPOSITORY ?= younger833/hivision_idphotos
IMAGE := $(REGISTRY)/$(IMAGE_REPOSITORY):$(VERSION)
DOCKER_PLATFORM ?= linux/$(ARCH)
HELM_RELEASE ?= photos
KUBE_NAMESPACE ?= default
CHART ?= deployments/photos
HELM ?= helm

.PHONY: build docker-build docker-push deploy

build: docker-build

docker-build:
	docker build --platform $(DOCKER_PLATFORM) -t $(IMAGE) .

docker-push: docker-build
	docker push $(IMAGE)

deploy:
	$(HELM) upgrade --install $(HELM_RELEASE) $(CHART) --namespace $(KUBE_NAMESPACE) --create-namespace --set-string image=$(IMAGE) --atomic --wait
