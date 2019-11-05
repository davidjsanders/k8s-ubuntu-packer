ifndef WORKDIR
  override WORKDIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
endif

ifndef IMAGE_NAME
  override IMAGE_NAME := "dsanderscan/docker-packer:19.10.3"
endif

ifndef TARGET
  override TARGET := image.json
endif

.PHONY: validate
validate:
	@start="`date`"; \
	docker run \
		--rm -it \
		--volume=$(WORKDIR):/data \
		--volume=$(WORKDIR)/secrets:/secrets \
		--volume=$(HOME)/.ssh:/ssh \
		$(IMAGE_NAME) validate \
			-var-file=/secrets/credentials.secret \
			-var-file=/data/vars/variables.json \
			$(TARGET) ; \
	echo ; \
	echo "Started validation at  : $$start"; \
	echo "Finished validation at : `date`"; \
	echo

.PHONY: build
build:
	@start="`date`"; \
	docker run \
		--rm -it \
		--volume=$(WORKDIR):/data \
		--volume=$(WORKDIR)/secrets:/secrets \
		--volume=$(HOME)/.ssh:/ssh \
		$(IMAGE_NAME) build \
			-var-file=/secrets/credentials.secret \
			-var-file=/data/vars/variables.json \
			$(TARGET) ; \
	echo ; \
	echo "Started validation at  : $$start"; \
	echo "Finished validation at : `date`"; \
	echo
