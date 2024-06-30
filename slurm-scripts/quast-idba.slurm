#!/bin/bash
##ENVIRONMENT SETTINGS; CHANGE WITH CAUTION
#SBATCH --export=NONE        #Do not propagate environment
#SBATCH --get-user-env=L     #Replicate login environment
  
##NECESSARY JOB SPECIFICATIONS
#SBATCH --job-name=eval-idba     #Set the job name to "JobExample1"
#SBATCH --time=72:00:00            #Set the wall clock limit to 1hr and 30min
#SBATCH --ntasks-per-node=1        #Request 1 task/core per node
#SBATCH --cpus-per-task=16
#SBATCH --mem=340GB                #Request 2560MB (2.5GB) per node
#SBATCH --output=quast-idba.%j    #Send stdout/err to "Example1Out.[jobID]"


module load GCC/9.3.0
module load OpenMPI/4.0.3
module load QUAST/5.0.2-Python-3.8.2

quast.py /scratch/group/hu-lab/meta-eukomics/assembly/idba-out/contig.fa \
        -1 /scratch/group/hu-lab/meta-eukomics/raw-data/HS039_S90_L004_R1_trimmed.fastq.gz -2 /scratch/group/hu-lab/meta-eukomics/raw-data/HS039_S90_L004_R2_trimmed.fastq.gz \
        -o /scratch/group/hu-lab/meta-eukomics/assembly/idba-out/ \
        --threads $SLURM_CPUS_PER_TASK
