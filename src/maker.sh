#!/bin/sh

if [ $# -lt 3 ]; then
    >&2 echo "Illegal number of parameters"
    return 1
fi

MAKER_ACTION="$1"; shift;
MAKER_TEXLIVE_YEAR="$1"; shift;
MAKER_TEXLIVE_SCHEMES="$@"
MAKER_TEXLIVE_LATEST=false
MAKER_TEXLIVE_DIRECTORY="$MAKER_TEXLIVE_YEAR"

if [ $MAKER_TEXLIVE_YEAR = "latest" ]; then
  MAKER_TEXLIVE_YEAR="2021"
fi

TAG_PREFIX="$CI_REGISTRY_IMAGE:$MAKER_TEXLIVE_YEAR-"
TAG_OTHERS="$CI_REGISTRY_IMAGE/$MAKER_TEXLIVE_YEAR: $DOCKER_REGISTRY/$DOCKER_PROJECT_PATH:$MAKER_TEXLIVE_YEAR-"

set -x

case $MAKER_ACTION in
  build)
    for MAKER_TEXLIVE_SCHEME in $MAKER_TEXLIVE_SCHEMES; do
      # Build the main image
      docker build \
        --pull \
        --tag $TAG_PREFIX$MAKER_TEXLIVE_SCHEME \
        --file "$MAKER_TEXLIVE_DIRECTORY/$MAKER_TEXLIVE_SCHEME.Dockerfile" \
        $MAKER_TEXLIVE_DIRECTORY/$MAKER_TEXLIVE_SCHEME.

      # Loop over each additional tag
      for TAG_OTHER in $TAG_OTHERS; do
        docker tag "$TAG_PREFIX$MAKER_TEXLIVE_SCHEME" "$TAG_OTHER$MAKER_TEXLIVE_SCHEME"
        if [ $MAKER_TEXLIVE_LATEST ]; then
          docker tag "$TAG_PREFIX$MAKER_TEXLIVE_SCHEME" "$( echo "$TAG_OTHER$MAKER_TEXLIVE_SCHEME" | sed s/$MAKER_TEXLIVE_YEAR/latest/g )"
        fi
        # Tag only the "FULL" scheme as an "un-schemed" image
        if [ $MAKER_TEXLIVE_SCHEME = "full" ]; then
          docker tag "$TAG_PREFIX$MAKER_TEXLIVE_SCHEME" "$( echo "$TAG_OTHER$MAKER_TEXLIVE_SCHEME" | sed s/$MAKER_TEXLIVE_YEAR.*/latest/g )"
        fi
      done

    done
    ;;
  push)
    for MAKER_TEXLIVE_SCHEME in $MAKER_TEXLIVE_SCHEMES; do
      # Push the main image
      docker push "$TAG_PREFIX$MAKER_TEXLIVE_SCHEME"

      # Loop over each additional tag
      for TAG_OTHER in $TAG_OTHERS; do
        docker push "$TAG_OTHER$MAKER_TEXLIVE_SCHEME"
        if [ $MAKER_TEXLIVE_LATEST ]; then
          docker push "$( echo "$TAG_OTHER$MAKER_TEXLIVE_SCHEME" | sed s/$MAKER_TEXLIVE_YEAR/latest/g )"
        fi
        # Tag only the "FULL" scheme as an "un-schemed" image
        if [ $MAKER_TEXLIVE_SCHEME = "full" ]; then
          docker push "$( echo "$TAG_OTHER$MAKER_TEXLIVE_SCHEME" | sed s/$MAKER_TEXLIVE_YEAR.*/latest/g )"
        fi
      done

    done
    ;;
esac

set +x

return 0
