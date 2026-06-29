#!/bin/bash
# new_case.sh
# Sets up a new PALM case directory
# Usage: bash new_case.sh <case_name>
# Example: bash new_case.sh brooklyn

CASE=$1
PALM_DIR=~/palm

if [ -z "$CASE" ]; then
    echo "Usage: bash new_case.sh <case_name>"
    exit 1
fi

echo "=== Creating case: $CASE ==="

mkdir -p $PALM_DIR/JOBS/$CASE/INPUT
mkdir -p $PALM_DIR/JOBS/$CASE/OUTPUT
mkdir -p $PALM_DIR/JOBS/$CASE/MONITORING

cp ~/PALM_v1/cases/CCNY/ccny_slurm.sh $PALM_DIR/JOBS/$CASE/${CASE}_slurm.sh
cp ~/PALM_v1/cases/CCNY/INPUT/ccny_p3d $PALM_DIR/JOBS/$CASE/INPUT/${CASE}_p3d

sed -i "s/ccny/$CASE/g" $PALM_DIR/JOBS/$CASE/${CASE}_slurm.sh
sed -i "s/ccny/$CASE/g" $PALM_DIR/JOBS/$CASE/INPUT/${CASE}_p3d

echo "=== Done ==="
echo "Edit $PALM_DIR/JOBS/$CASE/INPUT/${CASE}_p3d to set your domain parameters"
echo "Add your static driver to $PALM_DIR/JOBS/$CASE/INPUT/${CASE}_static"
echo "Submit with: sbatch $PALM_DIR/JOBS/$CASE/${CASE}_slurm.sh"
