#!/bin/bash
##ENVIRONMENT SETTINGS; CHANGE WITH CAUTION
#SBATCH --export=NONE        #Do not propagate environment
#SBATCH --get-user-env=L     #Replicate login environment
  
##NECESSARY JOB SPECIFICATIONS
#SBATCH --job-name=gzip     #Set the job name to "JobExample1"
#SBATCH --time=36:00:00            #Set the wall clock limit to 1hr and 30min
#SBATCH --ntasks-per-node=1                 #Request 1 task
#SBATCH --cpus-per-task=8
#SBATCH --mem=300G                #Request 2560MB (2.5GB) per node
#SBATCH --output=gzip.%j    #Send stdout/err to "Example1Out.[jobID]"


gzip /scratch/group/hu-lab/meta-eukomics/raw-data/HS039_S90_L004_R1_trimmed.fastq

echo "Completed zip of R1"

gzip /scratch/group/hu-lab/meta-eukomics/raw-data/HS039_S90_L004_R2_trimmed.fastq

echo "Completed zip of R2"

