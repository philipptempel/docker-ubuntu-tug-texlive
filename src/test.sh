#!/bin/bash

if [ $# -lt 1 ]; then
    >&2 echo "Illegal number of parameters. Must be 1 or more but received only $#"
    exit 1
fi

PRG="$0"
while [ -h "$PRG" ] ; do
   PRG=`readlink "$PRG"`
done
SRCDIR=`dirname $PRG`

# Include additional files
. $SRCDIR/functions.sh

# Include and parse constants
. $SRCDIR/constants.sh

TEXLIVE_SCHEMES="$@"

for TEXLIVE_SCHEME in $TEXLIVE_SCHEMES; do
  # Get image's main tag and all secondary tags
  MAIN_TAG=$(main_tag ${TEXLIVE_YEAR} ${TEXLIVE_SCHEME})
  OTHER_TAGS=$(other_tags ${TEXLIVE_YEAR} ${TEXLIVE_SCHEME})

  test_img $MAIN_TAG

  # Loop over each additional tag
  for OTHER_TAG in ${OTHER_TAGS}; do
    test_img $OTHER_TAG

  done

done
