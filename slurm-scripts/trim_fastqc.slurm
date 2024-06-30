#!/bin/bash
##ENVIRONMENT SETTINGS; CHANGE WITH CAUTION
#SBATCH --export=NONE        #Do not propagate environment
#SBATCH --get-user-env=L     #Replicate login environment
  
##NECESSARY JOB SPECIFICATIONS
#SBATCH --job-name=trim-fastqc     #Set the job name to "JobExample1"
#SBATCH --time=04:30:00            #Set the wall clock limit to 1hr and 30min
#SBATCH --ntasks=1                 #Request 1 task
#SBATCH --ntasks-per-node=1        #Request 1 task/core per node
#SBATCH --mem=2560M                #Request 2560MB (2.5GB) per node
#SBATCH --output=trim-fastqc.%j    #Send stdout/err to "Example1Out.[jobID]"

#First Executable Line
# This example requests 1 core on 1 node with 2.5 GB of RAM for 1.5 hours
# For graze, there are 48 cores with 384 GB of usable memory

export OMP_NUM_THREADS=16

module load Trimmomatic/0.39-Java-11

echo "Starting trimmomatic."

java -jar $EBROOTTRIMMOMATIC/trimmomatic-0.39.jar PE /scratch/group/hu-lab/meta-eukomics/raw-data/HS039_S90_L004_R1_001.fastq.gz /scratch/group/hu-lab/meta-eukomics/raw-data/HS039_S90_L004_R2_001.fastq.gz  /scratch/group/hu-lab/meta-eukomics/raw-data/HS039_S90_L004_R1_trimmed.fastq.gz /scratch/group/hu-lab/meta-eukomics/raw-data/HS039_S90_L004_R1_unpaired.fastq.gz /scratch/group/hu-lab/meta-eukomics/raw-data/HS039_S90_L004_R2_trimmed.fastq.gz /scratch/group/hu-lab/meta-eukomics/raw-data/HS039_S90_L004_R2_unpaired.fastq.gz ILLUMINACLIP:adapters-primers.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:10 MINLEN:50
echo "Trimmomtatic complete. Repeating fastqc"

module load FastQC/0.11.9-Java-11

fastqc /scratch/group/hu-lab/meta-eukomics/raw-data/HS039_S90_L004_R1_trimmed.fastq.gz
fastqc /scratch/group/hu-lab/meta-eukomics/raw-data/HS039_S90_L004_R2_trimmed.fastq.gz

echo "Complete"
