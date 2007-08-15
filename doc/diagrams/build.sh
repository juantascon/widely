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
	#dia -t png -e "$OUTPUT/$(basename $d .dia).png" "$d"
	dia -t eps-pango -e "$OUTPUT/$(basename $d .dia).eps" "$d"
done

for d in $DDIR/ui/*.svg
do
	#inkscape -b white -e "$OUTPUT/ui-$(basename $d .svg).png"  "$d"
	inkscape -b white -E "$OUTPUT/ui-$(basename $d .svg).eps"  "$d"
done

for eps in "$OUTPUT"/*.eps
do
	epstopdf $eps
done

