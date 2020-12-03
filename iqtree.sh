#!/bin/bash

#SBATCH --job-name=siph_iqtree
#SBATCH --time=20:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8

module load IQ-TREE/1.6.12

iqtree -s results/masked.fasta -bb 1000 -nt AUTO