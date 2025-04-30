

if ! [ $# -eq 1 ]; then
	echo "wrong number of args in buildBG.sh"
	exit 1
fi
# check for existance of BAM files
./checkBAM.sh $1
first_d=$(pwd)
cd "case$1/"

# build the bg files to export in UCSC

for BAMname in *.bam; do
	echo "building the ${BAMname%.bam}.bg file"
	# becareful to the name that will be passed to UCSC
	bedtools genomecov -ibam $BAMname -bg -trackline -trackopts "name=\"${BAMname%.bam}\"" -max 100 > "${BAMname%.bam}.bg"
	if ! [ -f "${BAMname%.bam}.bg" ]; then
		echo "no ${BAMname%.bam}.bg file has been created"
		exit 1
	fi
done
cd="${first_d}"
