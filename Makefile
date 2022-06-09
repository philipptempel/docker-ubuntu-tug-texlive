SHELL=/bin/sh

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
	TEXLIVE_YEAR="$(TEXLIVE_YEAR)" ./src/maker.sh build $*

push-%:
	TEXLIVE_YEAR="$(TEXLIVE_YEAR)" ./src/maker.sh push $*

clean-%:
	TEXLIVE_YEAR="$(TEXLIVE_YEAR)" ./src/maker.sh clean $*

test-%:
	TEXLIVE_YEAR="$(TEXLIVE_YEAR)" ./src/test.sh $*

ubuntu: build-ubuntu push-ubuntu

infraonly: ubuntu build-infraonly push-infraonly

minimal: infraonly build-minimal push-minimal

basic: minimal build-basic push-basic

small: basic build-small push-small

medium: small build-medium push-medium

full: medium build-full push-full
