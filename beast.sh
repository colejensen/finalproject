#!/bin/bash

# set the number of nodes
#SBATCH --nodes=1

# set max wallclock time
#SBATCH --time=200:00:00

# memory requirement
#SBATCH --mem=100g

# number of nodes
#SBATCH --nodes=1

# CPUs allocated to each task
#SBATCH --cpus-per-task=20

# mail alert at start, end and abortion of execution
#SBATCH --mail-type=BEGIN,END --mail-user=cole.jensen@yale.edu

module load Beast/1.10.4
module load beagle-lib/3.0.2-fosscuda-2018b

input=$1

beast -threads 20 -beagle_cpu -save_every 500000 -save_stem state $input