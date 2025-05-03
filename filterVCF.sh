#!/bin/bash
# the line above is needed to specify to use bash to run this program

if ! [ $# -eq 2 ]; then
	echo "wrong number of arguments for filter.VCF"
	exit 1
fi

# first we call the buildVCF.sh file that will build the VCF file if it doesn't exist
./buildVCF.sh $1
# then we change the directory
first_d=$(pwd)
cd case$1


## NOW WE FILTER FOR THE CORRECT GENOTYPE PATTERN ##

# this vector will look at which name has each column among the 10th, 11th and 12th
v=()
# depending on the element of the v vector pAR and pAD will contains
# a different genotype pattern order
pAR=()
pAD=()
for i in {0..2}; do
	# v store in the element the name of a genome (between father, mother and child)
	v[$i]=$(grep "##" -v  Trio$1.vcf | grep "#" | cut -f $((i + 10)))
	# check for the value assumed by v
	if [[ "${v[$i]}" == *"father"* || "${v[$i]}" == *"mother"* ]]; then
        	pAR["$i"]='0/1'
        	pAD["$i"]='0/0'
	elif [[ "${v[$i]}" == *"child"* ]]; then
        	pAR["$i"]='1/1'
        	pAD["$i"]='0/1'
	else
        	echo "unexpected name for reads columns in .vcf file"
		exit 1
	fi
done

if [[ "$2" == "AR" ]]; then
       	echo "what will be searched ${pAR[0]}.*${pAR[1]}.*${pAR[2]}"
        # First we write the header to the genotype filtered .vcf file
        grep "#" Trio$1.vcf > recessive$1.vcf
	# then we appended the genotype pattern specific lines
        grep "##" -v Trio$1.vcf | grep -E "${pAR[0]}.*${pAR[1]}.*${pAR[2]}" >> recessive$1.vcf
	filename="recessive"
elif [[ "$2" == "AD" ]]; then
       	grep "#" Trio$1.vcf > dominant$1.vcf
	# the pattern will change for the dominant case
        grep "##" -v Trio$1.vcf | grep -E "${pAD[0]}.*${pAD[1]}.*${pAD[2]}" >> dominant$1.vcf
	filename="dominant"
else
       	echo "invalid gene type argument they must be AD or AR"
	exit 1
fi

## NOW WE SORT ANF FILTER JUST FOR QUALITY  ##
# below the file with sorted names
bcftools query -l "${filename}${1}.vcf" | sort > sortingFile.txt

# here we filter for low quality variant calling (.qual)
bcftools view -S sortingFile.txt "${filename}${1}.vcf" | bcftools filter -i 'QUAL>20' > "${filename}${1}.qual.vcf" 

## NOW WE JUST CONSIDER THE REGION OF INTERESENT (.region)
bedtools intersect -header -a "${filename}${1}.qual.vcf" -b /home/BCG2025_genomics_exam/exons16Padded_sorted.bed > "${filename}${1}.qual.region.vcf"


cd "$first_d"


