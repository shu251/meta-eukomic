#!/bin/bash
##ENVIRONMENT SETTINGS; CHANGE WITH CAUTION
#SBATCH --export=NONE        #Do not propagate environment
#SBATCH --get-user-env=L     #Replicate login environment
  
##NECESSARY JOB SPECIFICATIONS
#SBATCH --job-name=idba-assembly     #Set the job name to "JobExample1"
#SBATCH --time=36:45:00            #Set the wall clock limit to 1hr and 30min
#SBATCH --ntasks-per-node=1                 #Request 1 task
#SBATCH --cpus-per-task=8
#SBATCH --mem=300G                #Request 2560MB (2.5GB) per node
#SBATCH --output=idba.%j    #Send stdout/err to "Example1Out.[jobID]"

#echo "unzip files"
#gunzip /scratch/group/hu-lab/meta-eukomics/raw-data/HS039_S90_L004_R*_trimmed.fastq.gz

echo "Assembly with IDBA-tran"

module load GCC/8.2.0-2.31.1
module load IDBA-UD/1.1.3


fq2fa --merge /scratch/group/hu-lab/meta-eukomics/raw-data/HS039_S90_L004_R1_trimmed.fastq /scratch/group/hu-lab/meta-eukomics/raw-data/HS039_S90_L004_R2_trimmed.fastq /scratch/group/hu-lab/meta-eukomics/assembly/merged-PE-for-idba.fa

echo "Start assembly"

idba_tran -r /scratch/group/hu-lab/meta-eukomics/assembly/merged-PE-for-idba.fa -o /scratch/group/hu-lab/meta-eukomics/assembly/idba-out --mink 20 --maxk 50 --step 5 --num_threads 16

echo "assembly completed"

