#!/bin/bash

if [ $# -lt 2 ]; then
    >&2 echo "Illegal number of parameters. Must be 2 but received only $#"
    return 1
fi

PRG="$0"
while [ -h "$PRG" ] ; do
   PRG=`readlink "$PRG"`
done
SRCDIR=`dirname $PRG`

# Include additional files
. $SRCDIR/functions.sh

# Include and parse constants
.$SRCDIR/constants.sh

for TEXLIVE_SCHEME in $TEXLIVE_SCHEMES; do
  # Get image's main tag and all secondary tags
  MAIN_TAG=$(main_tag ${TEXLIVE_YEAR} ${TEXLIVE_SCHEME})
  OTHER_TAGS=$(other_tags ${TEXLIVE_YEAR} ${TEXLIVE_SCHEME})

  test_ubuntuversion $MAIN_TAG
  test_tlmgr $MAIN_TAG
  test_python3 $MAIN_TAG

  # Loop over each additional tag
  for OTHER_TAG in ${OTHER_TAGS}; do
    test_ubuntuversion $OTHER_TAG
    test_tlmgr "$OTHER_TAG"
    test_python3 "$OTHER_TAG"

  done

done
