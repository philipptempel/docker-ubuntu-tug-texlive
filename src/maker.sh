#!/bin/bash

if [ $# -lt 3 ]; then
    >&2 echo "Illegal number of parameters. Must be 3 but received only $#"
    return 1
fi

DEBUG=${DEBUG:-""}

ACTION="$1"; shift;

TEXLIVE_YEAR="$1"; shift;

TEXLIVE_SCHEMES="$@"

TEXLIVE_REPO=${TEXLIVE_REPO:-"http://mirrors.ctan.org/systems/texlive/tlnet/"}

UBUNTU_FLAVOR=${UBUNTU_FLAVOR:-"focal"}

CI_REGISTRY=${CI_REGISTRY:-"registry.gitlab.com"}
CI_PROJECT_PATH=${CI_PROJECT_PATH:-"philipptempel/docker-ubuntu-tug-texlive"}
CI_REGISTRY_IMAGE=${CI_REGISTRY_IMAGE:-"${CI_REGISTRY}/${CI_PROJECT_PATH}"}
DOCKER_REGISTRY=${DOCKER_REGISTRY:-"docker.io"}
DOCKER_PROJECT_PATH=${DOCKER_PROJECT_PATH:-"philipptempel/docker-ubuntu-tug-texlive"}

BFLAGS=${BFLAGS:-""}

main_tag() {
  YEAR_="$1"
  SCHEME_="$2"
  
  echo "${CI_REGISTRY_IMAGE}/${YEAR_}:${SCHEME_}"
  
  return 0
}

other_tags() {
  YEAR_="$1"
  SCHEME_="$2"

  TAGS="${CI_REGISTRY_IMAGE}:${YEAR_}-${SCHEME_} ${DOCKER_REGISTRY}/${DOCKER_PROJECT_PATH}:${YEAR_}-${SCHEME_}"
  if [[ "${SCHEME_}" == "full" ]]; then
    TAGS="${TAGS} ${CI_REGISTRY_IMAGE}/${YEAR_}:latest ${CI_REGISTRY_IMAGE}:${YEAR_} ${DOCKER_REGISTRY}/${DOCKER_PROJECT_PATH}:${YEAR_}"
  fi

  echo ${TAGS}

  return 0
}

PRG="$0"
while [ -h "${PRG}" ] ; do
   PRG=`readlink "${PRG}"`
done
SRCDIR=`dirname ${PRG}`

case ${ACTION} in
  build)
    for TEXLIVE_SCHEME in ${TEXLIVE_SCHEMES}; do
      # Get image's main tag and all secondary tags
      MAIN_TAG=$(main_tag ${TEXLIVE_YEAR} ${TEXLIVE_SCHEME})
      OTHER_TAGS=$(other_tags ${TEXLIVE_YEAR} ${TEXLIVE_SCHEME})

      # Build main image
      $DEBUG docker build \
        --tag ${MAIN_TAG} \
        --build-arg "UBUNTU_FLAVOR=${UBUNTU_FLAVOR}" \
        --build-arg "TEXLIVE_YEAR=${TEXLIVE_YEAR}" \
        --build-arg "TEXLIVE_REPO=${TEXLIVE_REPO}" \
        --build-arg "TEXLIVE_SCHEME=${TEXLIVE_SCHEME}" \
        --file "${SRCDIR}/${TEXLIVE_SCHEME}.Dockerfile" \
        ${BFLAGS} \
        ${SRCDIR} || exit 1

      # Assign each additional tag 
      for OTHER_TAG in ${OTHER_TAGS}; do
        $DEBUG docker tag "${MAIN_TAG}" "${OTHER_TAG}"

      done || exit 1

    done || exit 1
    ;;
  push)
    for TEXLIVE_SCHEME in ${TEXLIVE_SCHEMES}; do
      # Get image's main tag and all secondary tags
      MAIN_TAG=$(main_tag ${TEXLIVE_YEAR} ${TEXLIVE_SCHEME})
      OTHER_TAGS=$(other_tags ${TEXLIVE_YEAR} ${TEXLIVE_SCHEME})

      # Push main image
      $DEBUG docker push "${MAIN_TAG}"

      # Assign each additional tag
      for OTHER_TAG in ${OTHER_TAGS}; do
        $DEBUG docker push "${OTHER_TAG}"

      done || exit 1

    done || exit 1
    ;;

esac || exit 1

set +x

exit 0
