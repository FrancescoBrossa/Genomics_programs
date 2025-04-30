#!/bin/bash
# the line above is needed to specify to use bash to run this program

# this program launch all the program needed to perform the genomics analysis

if ! [ $# -eq 2 ]; then
	echo "wrong number of arguments provided for allCommands.sh"
	exit 1
fi 
./importcases.sh $1
./mapFQfiles.sh $1
./buildVCF.sh $1
./filterVCF.sh $1 $2
./qualimapper.sh $1
./buildBG.sh $1
#6. controlGenotype.sh
