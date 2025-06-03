#!/bin/bash -l 
#SBATCH --job-name=pipeface_test
#SBATCH --account=pawsey0933
#SBATCH --partition=work
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=16000M
#SBATCH --nodes=1
#SBATCH --time=24:00:00
#SBATCH --mail-user=gavin.monahan@perkins.org.au
#SBATCH --mail-type=END
#SBATCH --error=%j.%x.err
#SBATCH --output=%j.%x.out

#Load nextflow & singularity
module load nextflow/23.10.0
module load singularity/4.1.0-slurm

export NXF_WORK=/scratch/pawsey0933/long_read/
export NXF_OPTS='-Xms1g -Xmx4g'

#Run the pipeline
cd /software/projects/pawsey0933/long_read/pipeface

nextflow run pipface.nf \
    -params-file ./config/parameters_pipeface.json \
    -config ./config/nextflow_pipeface.config \
    -config /software/projects/pawsey0933/gmonahan/T2T/bam2fastq/pawsey_setonix.config \
    -with-timeline \
    -with-dag \
    -with-report \
    -resume
