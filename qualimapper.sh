#!/bin/bash

if ! [ $# -eq 1 ]; then
	echo "wrong number of args for qualimapper.sh"
	exit 1
fi
# first check if they already exist bam files like for buildVCF.sh
./checkBAM.sh $1

# first we change our directory
first_d=$(pwd)
cd "case$1/"

# then we perform the fastqc command

for reads in *bam; do
        if ! [ -f "${reads%.bam}_fastqc.html" ]; then
                fastqc "${reads%.bam}.fq.gz"
        fi
done
# check if fastqc worked
for reads in *bam; do
	if ! [ -f "${reads%.bam}_fastqc.html" ]; then
		echo "${reads%.bam}_fastqc.html doesn't exist"
		exit 1
	fi
done 	
# then we iterate over the bam files to perform qualimap with and without 
# the reference genome
for bamFile in *bam; do
	qualimap bamqc -bam $bamFile -gff /home/BCG2025_genomics_exam/exons16Padded_sorted.bed -outdir "${bamFile%.bam}"
	if ! [ -d "${bamFile%.bam}" ]; then
                echo "${bamFile%.bam} folder doesn't exist"
                exit 1
        fi
done

# then we perform multiqc
multiqc ./

# rename the report to distinguish between them
mv multiqc_report.html multiqc_report$1.html
cd "$first_d"
