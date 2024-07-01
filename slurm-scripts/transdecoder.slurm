#!/bin/bash
##ENVIRONMENT SETTINGS; CHANGE WITH CAUTION
#SBATCH --export=NONE        #Do not propagate environment
#SBATCH --get-user-env=L     #Replicate login environment
  
##NECESSARY JOB SPECIFICATIONS
#SBATCH --job-name=predict     #Set the job name to "JobExample1"
#SBATCH --time=36:00:00            #Set the wall clock limit to 1hr and 30min
#SBATCH --ntasks-per-node=1        #Request 1 task/core per node
#SBATCH --cpus-per-task=16
#SBATCH --mem=250GB                #Request 2560MB (2.5GB) per node
#SBATCH --output=transdecoder.%j    #Send stdout/err to "Example1Out.[jobID]"


module load GCC/11.3.0
module load TransDecoder/5.5.0

#extract the long open reading frames
TransDecoder.LongOrfs -t /scratch/group/hu-lab/meta-eukomics/assembly/combined-assembly/combined-assemblies.fasta --output_dir /scratch/group/hu-lab/meta-eukomics/predictions/

# predict the likely coding regions
TransDecoder.Predict -t /scratch/group/hu-lab/meta-eukomics/assembly/combined-assembly/combined-assemblies.fasta --output_dir /scratch/group/hu-lab/meta-eukomics/predictions/

