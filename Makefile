SHELL=/bin/bash

YEAR ?= 2017
IMAGE ?= philipptempel/docker-ubuntu-tug-texlive

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

all: schemes pushes

schemes: $(SCHEMES_FULL)

pushes: $(PUSHES_FULL)

# Generic scheme target
scheme-%:
	docker build --tag $(IMAGE):$(YEAR)-$* --file $*/Dockerfile $*/

# Generic push target
push-%:
	docker push "$(IMAGE):$(YEAR)-$*"

# Only infrastructure
infraonly: scheme-infraonly push-infraonly

# Minimal depends on infrastructure
minimal: infraonly scheme-minimal push-minimal

# Basic depends on minimal
basic: minimal scheme-basic push-basic

# Small depends on basic
small: basic scheme-small push-small

# Medium depends on small
medium: small scheme-medium push-medium

# Full depends on medium
full: medium scheme-full push-full
