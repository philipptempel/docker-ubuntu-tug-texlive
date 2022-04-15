SHELL=/bin/bash

TEXLIVE_YEAR ?= latest
TEXLIVE_REPO ?= http://mirrors.ctan.org/systems/texlive/tlnet/

SCHEMES = ubuntu infraonly minimal basic small medium full
BUILDS_ALL = $(patsubst %,build-%,$(SCHEMES))
PUSHES_ALL = $(patsubst %,push-%,$(SCHEMES))

# order of creation
# 0) ubuntu
# 1) infraonly
# 2) minimal
# 3) basic
# 4) small
# 5) medium
# 6) full

# All target
.PHONY: all
all: build push

# Build everything
.PHONY: build
build: $(BUILDS_ALL)

# Push everything
.PHONY: push
push: $(PUSHES_ALL)

# Generic scheme target
build-container-%:
	./src/maker.sh build $(TEXLIVE_YEAR) $*

# Generic push target
push-container-%:
	./src/maker.sh push $(TEXLIVE_YEAR) $*

# Basic image
build-ubuntu: build-container-ubuntu
push-ubuntu: push-container-ubuntu
ubuntu: build-ubuntu push-ubuntu

# Infraonly depends on ubuntu
build-infraonly: build-ubuntu build-container-infraonly
push-infraonly: push-ubuntu push-container-infraonly
infraonly: ubuntu build-infraonly push-infraonly

# Minimal depends on infraonly
build-minimal: build-infraonly build-container-minimal
push-minimal: push-infraonly push-container-minimal
minimal: infraonly build-minimal push-minimal

# Basic depends on minimal
build-basic: build-minimal build-container-basic
push-basic: push-minimal push-container-basic
basic: minimal build-basic push-basic

# Small depends on basic
build-small: build-basic build-container-small
push-small: push-basic push-container-small
small: basic build-small push-small

# Medium depends on small
build-medium: build-small build-container-medium
push-medium: push-small push-container-medium
medium: small build-medium push-medium

# Full depends on medium
build-full: build-medium build-container-full
push-full: push-medium push-container-full
full: medium build-full push-full
