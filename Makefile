SHELL=/bin/bash

TEXLIVE_YEAR ?= latest
TEXLIVE_REPO ?= http://mirrors.ctan.org/systems/texlive/tlnet/
UBUNTU_FLAVOR ?= focal

SCHEMES = ubuntu infraonly minimal basic small medium full
BUILDS_ALL = $(patsubst %,build-%,$(SCHEMES))
PUSHES_ALL = $(patsubst %,push-%,$(SCHEMES))
CLEANS_ALL = $(patsubst %,clean-%,$(SCHEMES))

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

# Clean up everything
.PHONY: clean
clean: $(CLEANS_ALL)

# Generic scheme target
build-container-%:
	./src/maker.sh build $(TEXLIVE_YEAR) $*

# Generic push target
push-container-%:
	./src/maker.sh push $(TEXLIVE_YEAR) $*

# Generic clean target
clean-container-%:
	./src/maker.sh clean $(TEXLIVE_YEAR) $*

# Basic image
build-ubuntu: build-container-ubuntu
push-ubuntu: push-container-ubuntu
clean-ubuntu: clean-container-ubuntu
ubuntu: build-ubuntu push-ubuntu

# Infraonly depends on ubuntu
build-infraonly: build-container-infraonly
push-infraonly: push-container-infraonly
clean-infraonly: clean-container-infraonly
infraonly: ubuntu build-infraonly push-infraonly

# Minimal depends on infraonly
build-minimal: build-container-minimal
push-minimal: push-container-minimal
clean-minimal: clean-container-minimal
minimal: infraonly build-minimal push-minimal

# Basic depends on minimal
build-basic: build-container-basic
push-basic: push-container-basic
clean-basic: clean-container-basic
basic: minimal build-basic push-basic

# Small depends on basic
build-small: build-container-small
push-small: push-container-small
clean-small: clean-container-small
small: basic build-small push-small

# Medium depends on small
build-medium: build-container-medium
push-medium: push-container-medium
clean-medium: clean-container-medium
medium: small build-medium push-medium

# Full depends on medium
build-full: build-container-full
push-full: push-container-full
clean-full: clean-container-full
full: medium build-full push-full
