#!/bin/bash
##ENVIRONMENT SETTINGS; CHANGE WITH CAUTION
#SBATCH --export=NONE        #Do not propagate environment
#SBATCH --get-user-env=L     #Replicate login environment
  
##NECESSARY JOB SPECIFICATIONS
#SBATCH --job-name=megahit-assembly1     #Set the job name to "JobExample1"
#SBATCH --time=72:00:00            #Set the wall clock limit to 1hr and 30min
#SBATCH --ntasks=4                 #Request 1 task
#SBATCH --ntasks-per-node=4        #Request 1 task/core per node
#SBATCH --mem=350GB                #Request 2560MB (2.5GB) per node
#SBATCH --output=megahit.%j    #Send stdout/err to "Example1Out.[jobID]"

#First Executable Line
# This example requests 1 core on 1 node with 2.5 GB of RAM for 1.5 hours
# For graze, there are 48 cores with 384 GB of usable memory

export OMP_NUM_THREADS=16

echo "Assembly with MEGAHIT"

module load GCCcore/11.2.0
module load MEGAHIT/1.2.9

megahit -1 /scratch/group/hu-lab/meta-eukomics/raw-data/HS039_S90_L004_R1_trimmed.fastq.gz -2 /scratch/group/hu-lab/meta-eukomics/raw-data/HS039_S90_L004_R2_trimmed.fastq.gz -o /scratch/group/hu-lab/meta-eukomics/assembly/megahit-output --min-contig-len 1000 --presets meta-large

echo "Assembly complete"

