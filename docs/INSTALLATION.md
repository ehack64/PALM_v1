# PALM v25.10 Installation Guide - CCNY Lighthouse Cluster

## 1. Download PALM

```bash
cd ~
wget https://palm-model.org/releases/palm_model_system-v25.10.tar.gz
tar -xzf palm_model_system-v25.10.tar.gz
```

## 2. Copy Configuration File

```bash
cp ~/PALM_v1/PALM_setup/config/.palm.config.default ~/palm/.palm.config.default
```

Key settings in .palm.config.default:
- compiler: /data/homedirs/<user>/wrf_dependencies/mpich/bin/mpif90
- compiler flags: -O2 -ffree-line-length-none -fallow-argument-mismatch
- execute_command: srun --mpi=pmi2 -n {{mpi_tasks}} ./palm

## 3. Fix CMakeLists.txt

Change -Ofast to -O2 and add -fallow-argument-mismatch:

```bash
sed -i 's/set(PALM_COMPILER_OPTIONS "-Ofast -ffree-line-length-none")/set(PALM_COMPILER_OPTIONS "-O2 -ffree-line-length-none -fallow-argument-mismatch")/' ~/palm_model_system-v25.10/packages/palm/model/share/cmake/CMakeLists.txt
```

## 4. Compile PALM

```bash
cd ~/palm_model_system-v25.10
bash install -p $HOME/palm 2>&1 | tail -20
```

## 5. Verify Installation

```bash
ls ~/palm/bin/palmrun
ls ~/palm/MAKE_DEPOSITORY_default/palm
```

## Known Issues

- PALM must be compiled with -O2 not -Ofast (causes double free crash)
- srun --mpi=pmi2 must be used instead of mpirun on compute nodes
- Static driver must have nz+2 z-levels (102 for nz=100)
- fallow-argument-mismatch required for shared_memory_io_mod.f90 compatibility
