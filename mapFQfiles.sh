# we need to map all fq files of the Trio, we'll exploit the uni index
# to make the program as generic as possible we'll take as input the case number

# check if we have the right amount of args
if ! [ $# -eq 1 ]; then 
	echo " wrong number of argument for mapFQfiles"
	# this is the equivalent of raising an error 
	exit 1
fi 
# but also to make everything even more automatic we'll check if we already
# have the directory of the case, if not we import all the data exploting
# the algorithm we build ad hoc

[ -d "$1" ] || ./importcases.sh $1

# We want to change the wd to avoid to iterate over/casenumber/*fq
# because in that way the iterative variable would contain the relative
# path as well

first_d=$(pwd)
cd case$1/

# we skip the index building (bowtie2 index) cause it already existS

# we correct with --rg-id and -rg "SM:."
for name in *.fq.gz; do

	echo "building the index for ${name%.fq.gz}" 
	bowtie2 -U $name -x /home/BCG2025_genomics_exam/uni --rg-id "${name%.fq.gz}" --rg "SM:${name%.fq.gz}" | samtools view -Sb | samtools sort -o "${name%.fq.gz}.bam" 
	samtools index "${name%.fq.gz}.bam"
	# check if the commands created the bam file
	if ! [ -f "${name%.fq.gz}.bam" ]; then
		echo "${name%.fq.gz}.bam doesn't exist"
	fi 
done

# we return to the original wd
cd "$first_d"
