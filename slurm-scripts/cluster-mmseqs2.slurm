#!/bin/bash
##ENVIRONMENT SETTINGS; CHANGE WITH CAUTION
#SBATCH --export=NONE        #Do not propagate environment
#SBATCH --get-user-env=L     #Replicate login environment
  
##NECESSARY JOB SPECIFICATIONS
#SBATCH --job-name=mmseqs2     #Set the job name to "JobExample1"
#SBATCH --time=72:00:00            #Set the wall clock limit to 1hr and 30min
#SBATCH --ntasks-per-node=1        #Request 1 task/core per node
#SBATCH --cpus-per-task=32
#SBATCH --mem=340GB                #Request 2560MB (2.5GB) per node
#SBATCH --output=mmseq.%j    #Send stdout/err to "Example1Out.[jobID]"


# Precursor load to use MMseqs2 on HPRC
module load GCC/10.2.0
module load OpenMPI/4.0.5
module load MMseqs2/13-45111

mkdir /scratch/group/hu-lab/meta-eukomics/assembly/combined-assembly

cat /scratch/group/hu-lab/meta-eukomics/assembly/megahit-output/final.contigs.fa /scratch/group/hu-lab/meta-eukomics/assembly/idba-out/contig.fa > /scratch/group/hu-lab/meta-eukomics/assembly/combined-assembly/combined-assemblies.fasta


# Use the 'easy-linclust' option

mmseqs easy-linclust /scratch/group/hu-lab/meta-eukomics/assembly/combined-assembly/combined-assemblies.fasta /scratch/group/hu-lab/meta-eukomics/assembly/combined-assembly/clusterRes /scratch/group/hu-lab/meta-eukomics/assembly/combined-assembly/tmp --threads $SLURM_CPUS_PER_TASK

