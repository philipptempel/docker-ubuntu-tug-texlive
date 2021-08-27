SHELL=/bin/bash

TEXLIVE_YEAR ?= latest
CI_REGISTRY ?= registry.gitlab.com
CI_PROJECT_PATH ?= philipptempel/docker-ubuntu-tug-texlive
CI_REGISTRY_IMAGE ?= $(CI_REGISTRY)/$(CI_PROJECT_PATH)

SCHEMES = infraonly minimal basic small medium full
SCHEMES_FULL = $(patsubst %,scheme-%,$(SCHEMES))
PUSHES_FULL = $(patsubst %,push-%,$(SCHEMES))

# order of creation
# 1) infraonly
# 2) minimal
# 3) basic
# 4) small
# 5) medium
# 6) full

# all targets
.PHONY: all
all: build push

# also 
.PHONY: build
build: $(SCHEMES_FULL)

.PHONY: push
push: $(PUSHES_FULL)

# Generic scheme target
scheme-%:
	CI_REGISTRY_IMAGE="$(CI_REGISTRY_IMAGE)" ./maker.sh build $(TEXLIVE_YEAR) $*

# Generic push target
push-%:
	CI_REGISTRY_IMAGE="$(CI_REGISTRY_IMAGE)" ./maker.sh push $(TEXLIVE_YEAR) $*

# Only infrastructure
.PHONY: infraonly
infraonly: scheme-infraonly push-infraonly

# Minimal depends on infrastructure
.PHONY: minimal
minimal: infraonly scheme-minimal push-minimal

# Basic depends on minimal
.PHONY: basic
basic: minimal scheme-basic push-basic

# Small depends on basic
.PHONY: small
small: basic scheme-small push-small

# Medium depends on small
.PHONY: medium
medium: small scheme-medium push-medium

# Full depends on medium
.PHONY: full
full: medium
	echo "docker build \
		--tag $(CI_REGISTRY_IMAGE):$(IMAGE_YEAR)-$* \
		--tag $(CI_REGISTRY_IMAGE):$(IMAGE_YEAR) \
		--file $(IMAGE_YEAR)/full/Dockerfile \
		$(IMAGE_YEAR)/full/"
	echo "docker push "$(CI_REGISTRY_IMAGE):$(IMAGE_YEAR)-full""
	echo "docker push "$(CI_REGISTRY_IMAGE):$(IMAGE_YEAR)""

