#!/bin/bash

usage() { echo "Uasge: $0 [-i] input.gif [-c COL] [-f output file format] [-p output file prefix]" 1>&2; exit 1; }

col=0
tmp_file=".tmpfile"
format="gif"
prefix="sp-"

while getopts ":i:c:f:" opt; do
	case "$opt" in 
		i)
			files=${OPTARG}
			;;
		c)
			col=${OPTARG}
			re='^[0-9]+$'
			if ! [[ "$col" =~ $re ]] ; then
				echo "error: column not a number" >&2; exit 1
			fi
			;;
		f)
			format=${OPTARG}
			;;
		\?)
			usage
			;;
	esac
done

if [ $# -gt 0 ]; then
	files=$@
fi

for file in $files; do
	echo $file
	frame=$(convert $file -print "%n\n" /dev/null)
	echo have $frame frame
	convert "$file" "$tmp_file.png"
	if (( $col == 0 )) ; then
		convert "$tmp_file"*.png +append "$prefix${file%.*}.$format"
	fi
	rm $tmp_file*
done
