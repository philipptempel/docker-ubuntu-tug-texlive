#!/bin/bash

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

runin() {
  IMG="$1"; shift;
  docker run -it $IMG $@
}

test_img() {
  IMG="$1"; shift;

  echo "testing $IMG"

  echo "ubuntu `test_ubuntuversion $IMG`"
  echo "tlmgr `test_tlmgr $IMG`"
  echo "python3 `test_python3 $IMG`"
}

test_ubuntuversion() {
  runin $1 lsb_release -a | grep -i 'description'
}

test_tlmgr() {
  runin $1 which tlmgr
}

test_python3() {
  runin $1 python3 --version
}
