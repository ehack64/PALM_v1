# PALM Troubleshooting Guide - CCNY Lighthouse Cluster

## Issue 1: Segfault in topography_mod during Setup Topography

**Error:** Program received signal SIGSEGV during topography setup

**Cause:** buildings_3d array in static driver has fewer z-levels than PALM expects.
PALM topography_set_flags loops to nzt+1 (101) but array only allocated to nz (100).

**Fix:** Static driver must have nz+2 z-levels (102 for nz=100).
See cases/CCNY/docs/CCNY_CASE.md for the Python fix script.

## Issue 2: double free detected in tcache 2

**Error:** free(): double free detected - crashes immediately with more than 1 MPI process

**Cause:** PALM compiled with -Ofast causes memory corruption with modern glibc.

**Fix:** Recompile with -O2. Edit CMakeLists.txt and .palm.config.default.
Force recompile: touch palm.f90 and run bash install.

## Issue 3: palmrun crashes with wrong ending error

**Error:** file "ccny_static_100z" has wrong ending "_100z"

**Cause:** PALM checks all files in INPUT directory for valid naming conventions.

**Fix:** Remove temporary files from INPUT directory:
    rm ~/palm/JOBS/ccny/INPUT/ccny_static_backup
    rm ~/palm/JOBS/ccny/INPUT/ccny_static_100z

## Issue 4: mpirun crashes on compute nodes but works on login node

**Error:** BAD TERMINATION EXIT CODE 6 on compute nodes only

**Cause:** Old MPICH 3.0.4 has PMI compatibility issues with slurm on compute nodes.

**Fix:** Use srun instead of mpirun in .palm.config.default:
    %execute_command    srun --mpi=pmi2 -n {{mpi_tasks}} ./palm

## Issue 5: Type mismatch in argument baseptr

**Error:** Error: Type mismatch in argument baseptr passed TYPE(c_ptr) to INTEGER(8)

**Cause:** shared_memory_io_mod.f90 uses old MPI shared memory interface.

**Fix:** Add -fallow-argument-mismatch to compiler options in .palm.config.default and CMakeLists.txt.

## Issue 6: make Nothing to be done for all

**Cause:** palmbuild skips recompile if timestamps unchanged.

**Fix:**
    touch ~/palm_model_system-v25.10/packages/palm/model/src/palm.f90
    cd ~/palm_model_system-v25.10
    bash install -p $HOME/palm

## Issue 7: Config file ignored

**Cause:** Two config files exist. palmbuild uses ~/palm/.palm.config.default not ~/.palm.config.default.

**Fix:** Always edit ~/palm/.palm.config.default and verify with:
    grep compiler_options ~/palm/.palm.config.default

## Issue 8: node2 cannot find tmp directory

**Error:** slurmstepd-node2: couldn't chdir to palm/tmp/ccny.XXXXX

**Cause:** Multi-node job where nodes don't share filesystem.

**Fix:** Run on single node. Ensure shared filesystem access for multi-node runs.

## Issue 9: PALM z-coordinate mismatch

**Cause:** Static driver z-coordinates don't match PALM vertical grid.

**Fix:** PALM zu values for dz=5.0 are [0, 2.5, 7.5, 12.5 ...].
Ensure static driver z dimension matches exactly.

## Issue 10: npex/npey not recognized in PARIN

**Error:** reading fails on line X in namelist: npex = N

**Cause:** npex/npey are not valid PALM v25.10 namelist parameters.

**Fix:** Remove npex/npey from p3d file. PALM auto-decomposes the domain.
