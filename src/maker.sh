#!/bin/sh

if [ $# -lt 3 ]; then
    >&2 echo "Illegal number of parameters. Must be 3 but received only $#"
    return 1
fi

DEBUG=""

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

PRG="$0"
while [ -h "$PRG" ] ; do
   PRG=`readlink "$PRG"`
done
SRCDIR=`dirname $PRG`

TAG_PREFIX="$CI_REGISTRY_IMAGE/$TEXLIVE_YEAR:"
TAG_OTHERS="$CI_REGISTRY_IMAGE:$TEXLIVE_YEAR- $DOCKER_REGISTRY/$DOCKER_PROJECT_PATH:$TEXLIVE_YEAR-"

if [ ! -d "$SRCDIR/$TEXLIVE_YEAR" ]; then
  TAG_OTHERS="$TAG_OTHERS $CI_REGISTRY_IMAGE/latest: $CI_REGISTRY_IMAGE:latest- $DOCKER_REGISTRY/$DOCKER_PROJECT_PATH:latest-"
fi

case $ACTION in
  clean)
    for TEXLIVE_SCHEME in $TEXLIVE_SCHEMES; do
      # Loop over each additional tag
      for TAG_OTHER in $TAG_OTHERS; do
        $DEBUG docker rmi --force "$TAG_OTHER$TEXLIVE_SCHEME" || true

      done || exit 1

      # First, remove old tag
      $DEBUG docker rmi --force $TAG_PREFIX$TEXLIVE_SCHEME || true

    done || exit 1
    ;;

  build)
    for TEXLIVE_SCHEME in $TEXLIVE_SCHEMES; do
      # Build the main image
      $DEBUG docker build \
        --tag $TAG_PREFIX$TEXLIVE_SCHEME \
        --build-arg "UBUNTU_FLAVOR=${UBUNTU_FLAVOR}" \
        --build-arg "TEXLIVE_YEAR=${TEXLIVE_YEAR}" \
        --build-arg "TEXLIVE_REPO=${TEXLIVE_REPO}" \
        --build-arg "TEXLIVE_SCHEME=${TEXLIVE_SCHEME}" \
        --file "$SRCDIR/$TEXLIVE_SCHEME.Dockerfile" \
        $BFLAGS \
        $SRCDIR || exit 1

      # Loop over each additional tag
      for TAG_OTHER in $TAG_OTHERS; do
        $DEBUG docker tag "$TAG_PREFIX$TEXLIVE_SCHEME" "$TAG_OTHER$TEXLIVE_SCHEME"

      done || exit 1

    done || exit 1
    ;;

  push)
    for TEXLIVE_SCHEME in $TEXLIVE_SCHEMES; do
      # Push the main image
      $DEBUG docker push "$TAG_PREFIX$TEXLIVE_SCHEME"

      # Loop over each additional tag
      for TAG_OTHER in $TAG_OTHERS; do
        $DEBUG docker push "$TAG_OTHER$TEXLIVE_SCHEME"

      done || exit 1

    done || exit 1
    ;;
esac || exit 1

set +x

exit 0
