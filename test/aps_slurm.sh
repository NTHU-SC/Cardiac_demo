#!/bin/bash
#SBATCH -J heart_demo_aps
#SBATCH -A ACD114003
#SBATCH -p hpcxai1
#SBATCH -o heart_demo_aps_out_%j.log
#SBATCH -e heart_demo_aps_err_%j.log
#SBATCH -n 4
#SBATCH -n 56
#SBATCH -c 8

module load intel/2022_3_1
source /pkg/compiler/intel/2024/vtune/2024.0/vtune-vars.sh
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

cd ~/Cardiac_demo
make

rm -r test/aps_result_lab2

mpiexec aps --result-dir=test/aps_result_lab2 build/heart_demo -m mesh_mid -s setup_mid.txt -t 50 2>&1 > /dev/null

cd test
aps-report aps_result_lab2 -H aps_result_lab2.html
# rm -rf aps_result_lab2
