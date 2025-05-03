#!/bin/bash
#the line above tells to use the bash interpreter to run this program

# this program will take as argument the case number we want and return a copy of 
# the Trio child, mother, father we want

# FIRST
# THE program will check is a folder of the case exist if does not it will create it
[ -d "case$1" ] || mkdir -p "case$1"

# now create an array to take the child, mother and father .fq files for each case
nameArray=("child" "father" "mother")
i=0

# these lines check if there are already 3 .fq.gz files inside our folder
first_d=$(pwd)
cd case$1
vectorFQ=(*.fq.gz)
cd "$first_d"
if [ "${#vectorFQ[@]}" -eq 3 ]; then
	exit 0
fi

for person in /home/BCG2025_genomics_exam/case$1*.fq.gz; do
	# try to fix the names in order to have it homologpus to that of bam, and the qualimap folder
	# create a soft link with the files
 	ln -s $person case$1/${nameArray[$i]}$1.fq.gz
  	# check if the commands worked
	if ! [ -f "case$1/${nameArray[$i]}$1.fq.gz" ]; then
		echo "no case$1/${nameArray[$i]}$1.fq.gz is present in the folder"
		exit 1
	fi 
	i=$((i+1))
done

# we don't bother to import universe.fasta and the ref sequence cause it works 
# good in any case even exploting them with the path

