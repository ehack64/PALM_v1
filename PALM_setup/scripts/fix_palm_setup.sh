#!/bin/bash
# fix_palm_setup.sh
# Applies all required fixes to PALM v25.10 for CCNY lighthouse cluster
# Run this after downloading PALM but before compiling

PALM_SRC=~/palm_model_system-v25.10
PALM_DIR=~/palm

echo "=== Fixing CMakeLists.txt ==="
sed -i 's/set(PALM_COMPILER_OPTIONS "-Ofast -ffree-line-length-none")/set(PALM_COMPILER_OPTIONS "-O2 -ffree-line-length-none -fallow-argument-mismatch")/' \
    $PALM_SRC/packages/palm/model/share/cmake/CMakeLists.txt
sed -i 's/set(PALM_C_COMPILER_OPTIONS "-Ofast/set(PALM_C_COMPILER_OPTIONS "-O2/' \
    $PALM_SRC/packages/palm/model/share/cmake/CMakeLists.txt

echo "=== Copying config file ==="
cp ~/PALM_v1/PALM_setup/config/.palm.config.default $PALM_DIR/.palm.config.default

echo "=== Forcing recompile ==="
touch $PALM_SRC/packages/palm/model/src/palm.f90

echo "=== Compiling PALM ==="
cd $PALM_SRC
bash install -p $PALM_DIR 2>&1 | tail -20

echo "=== Done ==="
echo "Verify with: grep compiler_options $PALM_DIR/.palm.config.default"
