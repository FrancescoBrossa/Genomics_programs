#!/bin/bash
#the line above tells to use the bash interpreter to run this program

# this program will take as argument the number of the case we want and return a copy of 
# the Trio child, mother, father we want

# FIRST
# THE program will check is a folder of the case exist if does not it will create it

[ -d "case$1" ] || mkdir -p "case$1"

# now copy all three the files exploiting a loop
nameArray=("child" "father" "mother")
i=0
# we build a lighter version where we only use soft links so we're not going to 
# use the cp
# cp "$person" "case$1/${nameArray[$i]}$1.fq.gz" 
first_d=$(pwd)
cd case$1
vectorFQ=(*.fq.gz)
cd "$first_d"
if [ "${#vectorFQ[@]}" -eq 3 ]; then
	exit 0
fi
# takes the proper variables from the paths.txt file
path=$(grep "1cases-->" paths.txt | grep -P "/.*$")
echo "check if the path works ${path}case$1"

for person in /home/BCG2025_genomics_exam/case$1*.fq.gz; do
	# try to fix the names in order to have it homologpus to that of bam, and the qualimiap folder
	ln -s $person case$1/${nameArray[$i]}$1.fq.gz
	if ! [ -f "case$1/${nameArray[$i]}$1.fq.gz" ]; then
		echo "no case$1/${nameArray[$i]}$1.fq.gz is present in the folder"
		exit 1
	fi 
	i=$((i+1))
done

# we don't bother to import universe.fasta and the ref sequence cause it works 
# good in any case for the moment

