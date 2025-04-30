#!/bin/bash
# the line above is needed to speify to use bash for run this program

if ! [ $# -eq 1 ]; then
	echo "wrong number of argument for checkBAM.sh"
	exit 1
fi
# take as argument a folder number check
# 1. if the folder exists
[ -d "case$1" ] || ./importcases.sh $1
# 2, if it exists check if it there are BAM file inside
if ! [ -d "case$1" ]; then
	echo "importcases.sh didn't work"
	exit 1
fi

first_d=$(pwd)
cd case$1
pattern=(*.bam)
echo "${#pattern[@]}"
if ! [ ${#pattern[@]} -eq 3 ]; then
        echo "there are not 3 bam files inside the folder"
        ../mapFQfiles.sh $1
fi
# now check if mapFQfiles.sh worked

if ! [ ${#pattern[@]} -eq 3 ]; then
        echo "mapFQfiles.sh didn't work"
        exit 1
fi


cd "$first_d"
