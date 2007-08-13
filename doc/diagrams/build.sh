#! /bin/bash

# letter - 6 cm
#WIDTH=530 # px

# letter - 5 cm
#HEIGHT=770 # px

DDIR="$(cd $(dirname $0) && pwd)"
OUTPUT="$DDIR/output"

mkdir -p $OUTPUT

for d in $DDIR/*.dia
do
	dia -e "$OUTPUT/$(basename $d).png" "$d"
done

for d in $DDIR/ui/*.svg
do
	inkscape -b white -e "$OUTPUT/ui-$(basename $d).png"  "$d"
done

