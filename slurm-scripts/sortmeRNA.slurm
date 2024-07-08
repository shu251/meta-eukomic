#!/bin/bash
##ENVIRONMENT SETTINGS; CHANGE WITH CAUTION
#SBATCH --export=NONE        #Do not propagate environment
#SBATCH --get-user-env=L     #Replicate login environment
  
##NECESSARY JOB SPECIFICATIONS
#SBATCH --job-name=sortmerna     #Set the job name to "JobExample1"
#SBATCH --time=72:00:00            #Set the wall clock limit to 1hr and 30min
#SBATCH --ntasks-per-node=1        #Request 1 task/core per node
#SBATCH --cpus-per-task=32
#SBATCH --mem=100GB                #Request 2560MB (2.5GB) per node
#SBATCH --output=sortmerna.%j    #Send stdout/err to "Example1Out.[jobID]"

# To use conda, include this line:
eval "$(conda shell.bash hook)"

# Load anaconda
module load Anaconda3/2022.05
conda activate sortmerna_env

mkdir /scratch/group/hu-lab/meta-eukomics/rRNA-sort-2

sortmerna -ref /scratch/group/hu-lab/meta-eukomics/rRNA_databases_v4/smr_v4.3_sensitive_db.fasta \
-reads /scratch/group/hu-lab/meta-eukomics/raw-data/HS039_S90_L004_R1_trimmed.fastq.gz \
-reads /scratch/group/hu-lab/meta-eukomics/raw-data/HS039_S90_L004_R2_trimmed.fastq.gz \
-workdir /scratch/group/hu-lab/meta-eukomics/rRNA-sort/ -aligned rRNA_aligned -other non_rRNA -fastx --paired_in --out2 --threads $SLURM_CPUS_PER_TASK
