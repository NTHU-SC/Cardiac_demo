#!/bin/bash
#SBATCH -J heart_demo_aps
#SBATCH -A ACD110018
#SBATCH -p ct224
#SBATCH -o heart_demo_aps_out_%j.log
#SBATCH -e heart_demo_aps_err_%j.log
#SBATCH -n 4
#SBATCH -n 56
#SBATCH -c 4

. /opt/ohpc/Taiwania3/pkg/intel/2022.2/setvars.sh
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

cd ~/Cardiac_demo
make

mpiexec aps --result-dir=test/aps_result_lab2 build/heart_demo -m mesh_mid -s setup_mid.txt -t 50 2>&1 > /dev/null
# mpiexec -aps build/heart_demo -m mesh_mid -s setup_mid.txt -t 50 2>&1 > /dev/null

cd test
aps-report aps_result_lab2
# rm -rf aps_result_lab2
