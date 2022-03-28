#!/bin/sh

if [ $# -lt 3 ]; then
    >&2 echo "Illegal number of parameters"
    return 1
fi

DEBUG=""

ACTION="$1"; shift;
TEXLIVE_YEAR="$1"; shift;
TEXLIVE_SCHEMES="$@"
TEXLIVE_LATEST=false
TEXLIVE_DIRECTORY="$TEXLIVE_YEAR"

CI_REGISTRY=${CI_REGISTRY:-"registry.gitlab.com"}
CI_PROJECT_PATH=${CI_PROJECT_PATH:-"philipptempel/docker-ubuntu-tug-texlive"}
CI_REGISTRY_IMAGE=${CI_REGISTRY_IMAGE:-"${CI_REGISTRY}/${CI_PROJECT_PATH}"}
DOCKER_REGISTRY=${DOCKER_REGISTRY:-"docker.io"}
DOCKER_PROJECT_PATH=${DOCKER_PROJECT_PATH:-"philipptempel/docker-ubuntu-tug-texlive"}

BFLAGS=${BFLAGS:-""}

PRG="$0"
while [ -h "$PRG" ] ; do
   PRG=`readlink "$PRG"`
done
SRCDIR=`dirname $PRG`

TAG_PREFIX="$CI_REGISTRY_IMAGE/$TEXLIVE_YEAR:"
TAG_OTHERS="$CI_REGISTRY_IMAGE:$TEXLIVE_YEAR- $DOCKER_REGISTRY/$DOCKER_PROJECT_PATH:$TEXLIVE_YEAR-"

if [ ! -d "$SRCDIR/$TEXLIVE_YEAR" ]; then
  TEXLIVE_DIRECTORY="latest"
  TAG_OTHERS="$TAG_OTHERS $CI_REGISTRY_IMAGE/latest: $CI_REGISTRY_IMAGE:latest- $DOCKER_REGISTRY/$DOCKER_PROJECT_PATH:latest-"
fi

case $ACTION in
  build)
    for TEXLIVE_SCHEME in $TEXLIVE_SCHEMES; do
      # Build the main image
      $DEBUG docker build \
        --tag $TAG_PREFIX$TEXLIVE_SCHEME \
        --file "$SRCDIR/$TEXLIVE_DIRECTORY/$TEXLIVE_SCHEME.Dockerfile" \
        $BFLAGS \
        $SRCDIR

      # Loop over each additional tag
      for TAG_OTHER in $TAG_OTHERS; do
        $DEBUG docker tag "$TAG_PREFIX$TEXLIVE_SCHEME" "$TAG_OTHER$TEXLIVE_SCHEME"

      done

    done
    ;;
  push)
    for TEXLIVE_SCHEME in $TEXLIVE_SCHEMES; do
      # Push the main image
      $DEBUG docker push "$TAG_PREFIX$TEXLIVE_SCHEME"

      # Loop over each additional tag
      for TAG_OTHER in $TAG_OTHERS; do
        $DEBUG docker push "$TAG_OTHER$TEXLIVE_SCHEME"

      done

    done
    ;;
esac

set +x
