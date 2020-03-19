#!/bin/bash
#
# Re-run the code locally, to re-create the data and figure.
#
# Usage:
#
#   ./scripts/rerun.sh
#
#
#SBATCH --partition=gelifes
#SBATCH --time=5:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --ntasks=1
#SBATCH --mem=10G
#SBATCH --job-name=pirex26
#SBATCH --output=example_26.log
module load R

rm -rf example_26
rm errors.png
time Rscript example_26.R
zip -r pirouette_example_26.zip example_26 example_26.R scripts errors.png

