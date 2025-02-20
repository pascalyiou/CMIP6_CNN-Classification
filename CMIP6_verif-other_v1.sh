#!/bin/bash -l
## Lancement en BATCH de classifications de modeles par tensorflow
## Pascal Yiou (LSCE), Dec. 2024
## Se lance sur HAL par:
## sbatch ${HOME}/programmes/RStat/CMIP6class/CMIP6_verif-other_v1.sh NMOD JOBID

# Instructions SBATCH always at the beginning of the script!

# Change the working directory before the execution of the job.
# Warning: the environment variables, e.g. $HOME,
# are not interpreted for the SBATCH instructions.
# Writing absolute paths is recommended.
#SBATCH -D /home/pyiou/programmes/RStat/CMIP6class

# The job partition (maximum elapsed time of the job).
##SBATCH --partition=day  

# The name of the job.
#SBATCH -J CMIP6_classif-v1.sh

# The number of GPU cards requested.
#SBATCH --gres=gpu:1

# Email notifications (e.g. the beginning and the end of the job).
#SBATCH --mail-user=pascal.yiou@lsce.ipsl.fr
#SBATCH --mail-type=all

# The path of the job log files.
# The error and the output logs can be merged into the same file.
# %j implements a job counter.
#SBATCH --error=slurm-%j.err
#SBATCH --output=slurm-%j.out

# Overtakes the system memory limits.
ulimit -s unlimited

# slurm in environment variable SLURM_CPUS_PER_TASK
export NUM_CPUS=$SLURM_CPUS_PER_TASK

##JOBID=${SLURM_JOB_ID}
JOBID=$2

start_date=`date +"%m/%d/%Y (%H:%M)"`
echo -e "\n\nStarting script at: ${start_date}\n"

module purge
module load R/4.4.1 tensorflow/2.15.0

## Nombre de modèles
NMOD=$1

## R CMD BATCH "--args SAISON NMOD JOBID" ${HOME}/programmes/RStat/CMIP6class/CMIP6_tensorflow-verif-other.R


R CMD BATCH "--args JJA ${NMOD} ${JOBID}" ${HOME}/programmes/RStat/CMIP6class/CMIP6_tensorflow-verif-other.R
R CMD BATCH "--args DJF ${NMOD} ${JOBID}" ${HOME}/programmes/RStat/CMIP6class/CMIP6_tensorflow-verif-other.R
R CMD BATCH "--args MAM ${NMOD} ${JOBID}" ${HOME}/programmes/RStat/CMIP6class/CMIP6_tensorflow-verif-other.R
R CMD BATCH "--args SON ${NMOD} ${JOBID}" ${HOME}/programmes/RStat/CMIP6class/CMIP6_tensorflow-verif-other.R

## Figure de synthèse
R CMD BATCH "--args ${NMOD} ${JOBID}" ${HOME}/programmes/RStat/CMIP6class/CMIP6_verif-other_plots.R

end_date=`date +"%m/%d/%Y (%H:%M)"`
echo -e "\nScript finished at: ${end_date}\n"
