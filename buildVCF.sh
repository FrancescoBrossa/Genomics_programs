#!/bin/bash
# the line above is needed to specify to use bash to run this program

# remember to check the cardinality of args
if ! [ $# -eq 1 ]; then
	echo "wrong number of arguments on buildVCF.sh program"
	exit 1
fi
# check if the BAM files exist
./checkBAM.sh $1
first_=$(pwd)
cd case$1
# vector declaration
names=(*.bam)
# similarly we perform this only if we don't have already a .vcf file
vcfFiles=(*.vcf)
if ! [ -f Trio$1.vcf ]; then
	echo " building Trio$1.vcf file"
# with the ${names[@]} we will consinder each element of the vecotr separately 
	freebayes  -f /home/BCG2025_genomics_exam/universe.fasta -m 20 -C 5 -Q 10 --min-coverage 10 "${names[@]}" > Trio$1.vcf
	echo "freebayes has done"
fi
if ! [ -f Trio$1.vcf ]; then
        echo " the Trio$1.vcf file has not been created"
	exit 1
fi


