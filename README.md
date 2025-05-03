# IN THE FOLLOWING FILE WE WILL DESCRIBE THE GENERAL STRUCTURE OF OUR PROGRAMS
## WE START HERE DESCRIBING THE CONDITIONS IN WHICH WE EXPLOITED SUCH PROGRAMS
### 1. CASES, REFERENCE SEQUENCE AND BOWTIE2 INDEX ARE PRESENT IN THE /home/BCG2025_genomics_exam/
*the user who wanted to change such paths needs to change


## HERE WE EXPLAIN THE WORKFLOW OF OUR PROGRAMS USED TO ANALYZE GENOMICS DATA,
### WE IMPLEMENT PROGRAMS TO SOLVE THE FOLLOWING TASKS 
- mapping reads over a reference genome
- build .vcf files in order to indentify the variants presents in input sequences
- build reports about the general quality of reads contained in .fasta (or .fq) files
- build .bg file that can be exported on UCSC genome browser to graphically evaluate variants


*The order in which programs are presented matters*
### EACH PROGRAM OF THE LIST WILL BE BRIEFLY DESCRIBED:
1. importcases.sh
2. mapFQfiles.sh
3. buildVCF.sh
4. filterVCF.sh 
5. qualimapper.sh
6. buildBG.sh

### INTRODUCTION TO SH PROGRAMS
*the ratio behind the splitting of the work in different program is "to let different programs perform different actions" that enable some flexibility in their usage but it required check methods to evaluate whether the program can be run or not (if the input files of some program don't exist you have to first built them)
To enable each program to run in any situations we connected them, so if the directory lacks in some files the correct program will be launched (e.g. if we want to lauch the mapping program mapFQfiles.sh but we don't have the .fq starting files the program will check for their existance and launch the corresponding program if they don't exist yet).*

# here below it's the legend that descirbe the kind of arguments our programs may need
## ARGUMENT LEGENT ##
fn = folder number
gt = gene type

1. IMPORTCASES.SH ARGUMENT: fn

the program check if the case$fn exists (if not it builds the folder)
the program will then check if 
then create a soft link for mother, father and child of such case in the
case$fn folder

2. MAPFQFILES.SH ARGUMENT: fn

the program call importcases.sh to check the existence of the directory

then exploit the uni index build up from universe.fasta in the BCG2025_genomics_exam/ directory
to build SAM files (for each fq file) where to annotate which portion of the reference genome
the reads of fq files cover
In a pipeline we actually covert those SAM files with samtools to bam files 

3. BUILDVCF.SH ARGUMENT: fn
this program check for BAM files existance (launching checkBAM.sh)
then simply create the .vcf file out of the 3 BAM files 

3.5 FILTERVCF.sh ARGUMENT: fn, gt

this program check for .vcf file existance (calling buildVCF.sh) and create 3 different files
- first the .vcf file that contains only the lines with the correct genotype pattern
- second the .vcf file that filtered out low quality variant called
- last the .vcf file that contains only the variant present in the exome regions

the presence of  3 different files eable to check whether some filter work badly

4. QUALIMAPPER.SH ARGUMENT: fn

it first launch checkBAM.sh program
this program produce the fastqc and qualimap reports
if them summarize all with the multiqc

5. BUILDBG.SH ARGUMENT: fn

this program launch checkBAM.sh to check the existance of BAM files

this program build bg files out of bam files, they are usefull to see the base coverage of interesing
DNA regions on the UCSC genome browser
