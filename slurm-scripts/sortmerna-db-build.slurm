#!/bin/bash
##ENVIRONMENT SETTINGS; CHANGE WITH CAUTION
#SBATCH --export=NONE        #Do not propagate environment
#SBATCH --get-user-env=L     #Replicate login environment
  
##NECESSARY JOB SPECIFICATIONS
#SBATCH --job-name=sortmerna-dbs     #Set the job name to "JobExample1"
#SBATCH --time=48:00:00            #Set the wall clock limit to 1hr and 30min
#SBATCH --ntasks-per-node=1        #Request 1 task/core per node
#SBATCH --cpus-per-task=12
#SBATCH --mem=340GB                #Request 2560MB (2.5GB) per node
#SBATCH --output=sortmerna-dbs.%j    #Send stdout/err to "Example1Out.[jobID]"


# Move to the location you want your rRNA databases stored
cd /scratch/group/hu-lab/meta-eukomics/ 

# Download from github release 
wget https://github.com/biocore/sortmerna/releases/download/v4.3.4/database.tar.gz

echo "Downloaded, now unzipped databases"

# Make new directory for this and un-zip downloaded file
mkdir rRNA_databases_v4
tar -xvf database.tar.gz -C rRNA_databases_v4


