# PALM Urban LES - CCNY

This repository contains setup, configuration, and case files for running PALM (Parallelized Large-Eddy Simulation Model) v25.10 on the CCNY lighthouse cluster.

## Repository Structure

    PALM_v1/
    ├── PALM_setup/
    │   ├── config/          # PALM configuration file
    │   └── scripts/         # Installation and setup scripts
    ├── cases/
    │   └── CCNY/
    │       ├── INPUT/       # PALM input files (p3d namelist)
    │       ├── docs/        # Case-specific documentation
    │       └── ccny_slurm.sh
    └── docs/                # General documentation

## Quick Start

See docs/INSTALLATION.md for full installation instructions.
See cases/CCNY/docs/CCNY_CASE.md for the CCNY case setup.

## Requirements

- PALM v25.10
- MPICH 3.0.4 (wrf_dependencies)
- NetCDF4
- FFTW3
- RRTMG

## Key Fixes Applied

- Static driver requires 102 z-levels (nz+2) for topography module compatibility
- Use srun --mpi=pmi2 instead of mpirun for compute node compatibility
- Compiler flags: -O2 -ffree-line-length-none -fallow-argument-mismatch
