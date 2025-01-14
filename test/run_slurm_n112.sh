#!/bin/bash
#SBATCH -J heart_demo_n112
#SBATCH -A ACD114003
#SBATCH -p hpcxai1
#SBATCH -o heart_demo_n112_out_%j.log
#SBATCH -e heart_demo_n112_err_%j.log
#SBATCH -N 4
#SBATCH -n 112
#SBATCH -c 4

module load intel/2022_3_1
source /pkg/compiler/intel/2022_3_1/setvars.sh
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
echo n=$SLURM_NTASKS

cd ~/Cardiac_demo
make

cd build
time mpiexec ./heart_demo -m ../mesh_mid -s ../setup_mid.txt -t 50 2>&1 > /dev/null
