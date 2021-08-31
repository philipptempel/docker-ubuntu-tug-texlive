#!/bin/sh

if [ $# -lt 3 ]; then
    >&2 echo "Illegal number of parameters"
    return 1
fi

MAKER_ACTION="$1"; shift;
MAKER_TEXLIVE_YEAR="$1"; shift;
MAKER_TEXLIVE_SCHEMES="$@"

MAINTAG="$CI_REGISTRY_IMAGE:$MAKER_TEXLIVE_YEAR-"
TAGS="$CI_REGISTRY_IMAGE/$MAKER_TEXLIVE_YEAR: $DOCKER_REGISTRY/$DOCKER_PROJECT_PATH:$MAKER_TEXLIVE_YEAR-"

if [ $MAKER_TEXLIVE_YEAR = "latest" ]; then
  CURRENT_YEAR=$(($(ls -d 2* | sort | tail -n 1) + 1))
  TAGS="$TAGS $CI_REGISTRY_IMAGE/$CURRENT_YEAR:"
  TAGS="$TAGS $DOCKER_REGISTRY/$DOCKER_PROJECT_PATH:$CURRENT_YEAR-"
fi

set -x

case $MAKER_ACTION in
  build)
    for MAKER_TEXLIVE_SCHEME in $MAKER_TEXLIVE_SCHEMES; do
      # Build the main image
      docker build \
        --pull \
        --tag $MAINTAG$MAKER_TEXLIVE_SCHEME \
        --file "$MAKER_TEXLIVE_YEAR/$MAKER_TEXLIVE_SCHEME/Dockerfile" \
        $MAKER_TEXLIVE_YEAR/$MAKER_TEXLIVE_SCHEME/

      # Loop over each additional tag
      for TAG in $TAGS; do
        docker tag "$MAINTAG$MAKER_TEXLIVE_SCHEME" "$TAG$MAKER_TEXLIVE_SCHEME"
      done

      # Tag only the "FULL" scheme as an "un-schemed" image
      if [ $MAKER_TEXLIVE_SCHEME = "full" ]; then
        docker tag "$MAINTAG$MAKER_TEXLIVE_SCHEME" "`expr " $MAINTAG" : ' \(.*\).'`"
      fi

    done
    ;;
  push)
    for MAKER_TEXLIVE_SCHEME in $MAKER_TEXLIVE_SCHEMES; do
      # Push the main image
      docker push "$MAINTAG$MAKER_TEXLIVE_SCHEME"

      # Push all other tags
      for TAG in $TAGS; do
        docker push "$TAG$MAKER_TEXLIVE_SCHEME"
      done

      # Push the "FULL" "un-schemed" image
      if [ $MAKER_TEXLIVE_SCHEME = "full" ]; then
        docker push "`expr " $MAINTAG" : ' \(.*\).'`"
      fi

    done
    ;;
esac

set +x

return 0
