#!/bin/bash -l 
#SBATCH --job-name=pipeface
#SBATCH --account=pawsey0933
#SBATCH --partition=long
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=16000M
#SBATCH --nodes=1
#SBATCH --time=2-0:00:00
#SBATCH --mail-user=gavin.monahan@perkins.org.au
#SBATCH --mail-type=END
#SBATCH --error=logs/%j/%j.%x.err
#SBATCH --output=logs/%j/%j.%x.out

cd /software/projects/pawsey0933/long_read/pipeface
mkdir -p logs/$SLURM_JOB_ID

#Load nextflow & singularity
module load nextflow/24.10.0
module load singularity/4.1.0-slurm

#Set nextflow variables
export NXF_WORK=/scratch/pawsey0933/long_read/
export NXF_OPTS='-Xms1g -Xmx4g'

#Run the pipeline
nextflow run pipeface.nf \
    -params-file ./config/parameters_pipeface.json \
    -config ./config/nextflow_pipeface_setonix.config \
    -config /software/projects/pawsey0933/gmonahan/T2T/bam2fastq/pawsey_setonix.config \
    -with-timeline logs/$SLURM_JOB_ID/timeline.html \
    -with-dag logs/$SLURM_JOB_ID/dag.html \
    -with-report logs/$SLURM_JOB_ID/report.html \
    -with-conda \
    -resume
