SHELL=/bin/bash

TEXLIVE_YEAR ?= latest
TEXLIVE_REPO ?= http://mirrors.ctan.org/systems/texlive/tlnet/
UBUNTU_FLAVOR ?= focal

SCHEMES = ubuntu infraonly minimal basic small medium full
BUILDS_ALL = $(patsubst %,build-%,$(SCHEMES))
PUSHES_ALL = $(patsubst %,push-%,$(SCHEMES))
CLEANS_ALL = $(patsubst %,clean-%,$(SCHEMES))
TEST_ALL = $(patsubst %,test-%,$(SCHEMES))

# order of creation
# 0) ubuntu
# 1) infraonly
# 2) minimal
# 3) basic
# 4) small
# 5) medium
# 6) full

# ALL target
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

# Test everything
.PHONY: test
test: $(TEST_ALL)

# Generic targets
build-%:
	./src/maker.sh build $(TEXLIVE_YEAR) $*

push-%:
	./src/maker.sh push $(TEXLIVE_YEAR) $*

clean-%:
	./src/maker.sh clean $(TEXLIVE_YEAR) $*

test-%:
	./src/test.sh $(TEXLIVE_YEAR) $*

ubuntu: build-ubuntu push-ubuntu

infraonly: build-infraonly push-infraonly

minimal: build-minimal push-minimal

basic: build-basic push-basic

small: build-small push-small

medium: build-medium push-medium

full: build-full push-full
