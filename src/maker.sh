#!/bin/bash

if [ $# -lt 2 ]; then
    >&2 echo "Illegal number of parameters. Must be 2 or more but received only $#"
    exit 1
fi

PRG="$0"
while [ -h "$PRG" ] ; do
   PRG=`readlink "$PRG"`
done
SRCDIR=`dirname $PRG`

# Include additional files
. $SRCDIR/functions.sh

ACTION="$1"; shift;

# Include and parse constants
. $SRCDIR/constants.sh

case $ACTION in
  clean)
    for TEXLIVE_SCHEME in $TEXLIVE_SCHEMES; do
      # Get image's main tag and all secondary tags
      MAIN_TAG=$(main_tag ${TEXLIVE_YEAR} ${TEXLIVE_SCHEME})
      OTHER_TAGS=$(other_tags ${TEXLIVE_YEAR} ${TEXLIVE_SCHEME})

      # Remove each additional tag
      for OTHER_TAG in ${OTHER_TAGS}; do
        $DEBUG docker rmi --force "${OTHER_TAG}" || true

      done || true

      # Remove main image
      $DEBUG docker rmi --force "${MAIN_TAG}" || true

    done || exit 1
    ;;

  build)
    for TEXLIVE_SCHEME in $TEXLIVE_SCHEMES; do
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
    for TEXLIVE_SCHEME in $TEXLIVE_SCHEMES; do
      # Get image's main tag and all secondary tags
      MAIN_TAG=$(main_tag ${TEXLIVE_YEAR} ${TEXLIVE_SCHEME})
      OTHER_TAGS=$(other_tags ${TEXLIVE_YEAR} ${TEXLIVE_SCHEME})

      # Push main image
      $DEBUG docker push "${MAIN_TAG}" || exit 1

      # Assign each additional tag
      for OTHER_TAG in ${OTHER_TAGS}; do
        $DEBUG docker push "${OTHER_TAG}"

      done || exit 1

    done || exit 1
    ;;
esac || exit 1

set +x

exit 0
