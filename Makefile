REGISTRY=cfaprdbatchcr.azurecr.io/
IMAGE_NAME=cfa-epinow2-pipeline
BRANCH=$(shell git branch --show-current)
CONFIG_CONTAINER=rt-epinow2-config
CNTR_MGR=docker
ifeq ($(BRANCH), main)
TAG=latest
else
TAG=$(BRANCH)
endif

CONFIG=test.json
POOL="cfa-epinow2-$(TAG)"
TIMESTAMP:=$(shell  date -u +"%Y%m%d_%H%M%S")
JOB:=Rt-estimation-$(TIMESTAMP)

deps:
	$(CNTR_MGR) build -t $(REGISTRY)$(IMAGE_NAME)-dependencies:$(TAG) -f Dockerfile-dependencies

pull:
	az acr login --name 'cfaprdbatchcr'
	$(CNTR_MGR) pull $(REGISTRY)$(IMAGE_NAME)-dependencies:$(TAG)
	$(CNTR_MGR) pull $(REGISTRY)$(IMAGE_NAME):$(TAG)

build:
	$(CNTR_MGR) build -t $(REGISTRY)$(IMAGE_NAME):$(TAG) \
		--build-arg TAG=$(TAG) -f Dockerfile .

tag:
	$(CNTR_MGR) tag $(IMAGE_NAME):$(TAG) $(REGISTRY)$(IMAGE_NAME):$(TAG)

config:
	gh workflow run \
	  -R cdcgov/cfa-config-generator run-workload.yaml  \
	  -f disease=all \
	  -f state=all \
	  -f job_id=$(JOB)

run-batch:
	$(CNTR_MGR) build -f Dockerfile-batch -t batch . --no-cache
	$(CNTR_MGR) run --rm  \
	--env-file .env \
	-it \
	batch python job.py "$(REGISTRY)$(IMAGE_NAME):$(TAG)" "$(CONFIG_CONTAINER)" "$(POOL)" "$(JOB)"

run-prod: config
	@echo "Hanging for 15 seconds to wait for configs to generate"
	sleep 15
	$(CNTR_MGR) build -f Dockerfile-batch -t batch . --no-cache
	$(CNTR_MGR) run --rm  \
	--env-file .env \
	-it \
	batch python job.py "$(REGISTRY)$(IMAGE_NAME):$(TAG)" "$(CONFIG_CONTAINER)" "$(POOL)" "$(JOB)"

run:
	$(CNTR_MGR) run --mount type=bind,source=$(PWD),target=/mnt -it \
	--env-file .env \
	--rm $(REGISTRY)$(IMAGE_NAME):$(TAG) \
	Rscript -e "CFAEpiNow2Pipeline::orchestrate_pipeline('$(CONFIG)', config_container = 'rt-epinow2-config', input_dir = '/mnt/input', output_dir = '/mnt', output_container = 'zs-test-pipeline-update')"


up:
	$(CNTR_MGR) run --mount type=bind,source=$(PWD),target=/cfa-epinow2-pipeline -it \
	--env-file .env \
	--rm $(REGISTRY)$(IMAGE_NAME):$(TAG) /bin/bash

push:
	$(CNTR_MGR) push $(REGISTRY)$(IMAGE_NAME):$(TAG)

test-batch:
	gh workflow run \
	  -R cdcgov/cfa-config-generator run-workload.yaml  \
	  -f disease=all \
	  -f state=NY \
	  -f job_id=$(JOB)
	@echo "Hanging for 15 seconds to wait for configs to generate"
	sleep 15
	$(CNTR_MGR) build -f Dockerfile-batch -t batch . --no-cache
	$(CNTR_MGR) run --rm  \
	--env-file .env \
	-it \
	batch python job.py "$(REGISTRY)$(IMAGE_NAME):$(TAG)" "$(CONFIG_CONTAINER)" "$(POOL)" "$(JOB)"

test:
	Rscript -e "testthat::test_local()"

document:
	Rscript -e "roxygen2::roxygenize()"

check:
	Rscript -e "rcmdcheck::rcmdcheck()"
