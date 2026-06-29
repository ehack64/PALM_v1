#!/bin/bash
#SBATCH --job-name=ccny_palm
#SBATCH --partition=compute
#SBATCH --nodes=1
#SBATCH --ntasks=20
#SBATCH --ntasks-per-node=20
#SBATCH --time=24:00:00
#SBATCH --output=/data/homedirs/ehackchabot00/palm/JOBS/ccny/slurm_%j.out
#SBATCH --error=/data/homedirs/ehackchabot00/palm/JOBS/ccny/slurm_%j.err

export LD_LIBRARY_PATH=/data/homedirs/ehackchabot00/wrf_dependencies/netcdf/lib:/data/homedirs/ehackchabot00/wrf_dependencies/mpich/lib:/data/homedirs/ehackchabot00/.local/lib:/data/homedirs/ehackchabot00/palm/rrtmg/lib

export PATH=/data/homedirs/ehackchabot00/wrf_dependencies/mpich/bin:/usr/bin:/usr/local/bin:/data/homedirs/ehackchabot00/palm/bin:$PATH

cd /data/homedirs/ehackchabot00/palm
palmrun -r ccny -c default -a "d3#" -X 20 -v -z
