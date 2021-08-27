#!/bin/sh

if [[ $# -ne 3 ]]; then
    >&2 echo "Illegal number of parameters"
    return 1
fi

MAKER_ACTION="$1"; shift;
MAKER_TEXLIVE_YEAR="$1"; shift;
MAKER_TEXLIVE_SCHEMES="$@"

case $MAKER_ACTION in
  build)
    for MAKER_TEXLIVE_SCHEME in $MAKER_TEXLIVE_SCHEMES; do
      docker build \
        --tag "$CI_REGISTRY_IMAGE:$MAKER_TEXLIVE_YEAR-$MAKER_TEXLIVE_SCHEME" \
        --file "$MAKER_TEXLIVE_YEAR/$MAKER_TEXLIVE_SCHEME/Dockerfile" \
        $MAKER_TEXLIVE_YEAR/$MAKER_TEXLIVE_SCHEME/
    done
    ;;
  push)
    for MAKER_TEXLIVE_SCHEME in $MAKER_TEXLIVE_SCHEMES; do
      docker push "$CI_REGISTRY_IMAGE:$MAKER_TEXLIVE_YEAR-$MAKER_TEXLIVE_SCHEME"
    done
    ;;
esac

echo ""
echo ""

return 0
