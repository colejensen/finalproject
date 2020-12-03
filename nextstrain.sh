#!/bin/bash

# set the number of nodes
#SBATCH --nodes=1

# set max wallclock time
#SBATCH --time=48:00:00

# memory requirement
#SBATCH --mem=80g 

# number of nodes
#SBATCH --nodes=1

# CPUs allocated to each task
#SBATCH --cpus-per-task=16

# mail alert at start, end and abortion of execution
#SBATCH

module load miniconda
source activate nextstrain

snakemake export --unlock
snakemake export
