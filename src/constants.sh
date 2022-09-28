#!/bin/bash

TEXLIVE_YEAR=${TEXLIVE_YEAR:-"latest"}
TEXLIVE_REPO=${TEXLIVE_REPO:-"http://mirrors.ctan.org/systems/texlive/tlnet/"}
UBUNTU_FLAVOR=${UBUNTU_FLAVOR:-"focal"}

CI_REGISTRY=${CI_REGISTRY:-"registry.gitlab.com"}
CI_PROJECT_PATH=${CI_PROJECT_PATH:-"philipptempel/docker-ubuntu-tug-texlive"}
CI_REGISTRY_IMAGE=${CI_REGISTRY_IMAGE:-"${CI_REGISTRY}/${CI_PROJECT_PATH}"}
DOCKER_REGISTRY=${DOCKER_REGISTRY:-"docker.io"}
DOCKER_PROJECT_PATH=${DOCKER_PROJECT_PATH:-"philipptempel/docker-ubuntu-tug-texlive"}

BFLAGS=${BFLAGS:-""}
