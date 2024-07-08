#!/bin/bash
##ENVIRONMENT SETTINGS; CHANGE WITH CAUTION
#SBATCH --export=NONE        #Do not propagate environment
#SBATCH --get-user-env=L     #Replicate login environment
  
##NECESSARY JOB SPECIFICATIONS
#SBATCH --job-name=diamond     #Set the job name to "JobExample1"
#SBATCH --time=48:00:00            #Set the wall clock limit to 1hr and 30min
#SBATCH --ntasks-per-node=1        #Request 1 task/core per node
#SBATCH --cpus-per-task=32
#SBATCH --mem=300GB                #Request 2560MB (2.5GB) per node
#SBATCH --output=diamond-annot.%j    #Send stdout/err to "Example1Out.[jobID]"

module load GCC/11.2.0
module load DIAMOND/2.0.15

diamond blastp --threads $SLURM_CPUS_PER_TASK --query /scratch/group/hu-lab/meta-eukomics/assembly/combined-assembly/combined-assemblies.fasta.transdecoder.pep --db /scratch/group/hu-lab/marferret/data/MarFERReT.v1.1.1.dmnd -o /scratch/group/hu-lab/meta-eukomics/annotation/meta-eukomic_marferret_07082024.txt --sensitive --evalue 0.0001 --max-target-seqs 10 --outfmt 6 qseqid sseqid sallseqid evalue bitscore qlen slen

