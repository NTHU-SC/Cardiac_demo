#!/bin/bash
#SBATCH -J heart_vtune_vector
#SBATCH -A ACD114003
#SBATCH -p hpcxai1
#SBATCH -o heart_vtune_vector_out_%j.log
#SBATCH -e heart_vtune_vector_err_%j.log
#SBATCH -n 4
#SBATCH -n 56
#SBATCH -c 8

module load intel/2022_3_1
source /pkg/compiler/intel/2024/vtune/2024.0/vtune-vars.sh
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

cd ~/Cardiac_demo
make

export OMP_NUM_THREADS=8
rm -r test/vtune_lab3
mpiexec vtune -collect hpc-performance -r test/vtune_lab3 build/heart_demo -m mesh_mid -s setup_mid.txt -t 50 2>&1 > /dev/null
# mpirun -n 10 -ppn 5 -hosts art1,art2 -gtool "vtune -collect hpc-performance -r test/vtune_lab3: 0-9" build/heart_demo -m mesh_mid -s setup_mid.txt -i -t 50 2>&1 > /dev/null
# mpirun -n 10 -ppn 5 -hosts art1,art2 vtune -collect hpc-performance -r test/vtune_lab3 build/heart_demo -m mesh_mid -s setup_mid.txt -i -t 50 2>&1 > /dev/null

make clean
CXXFLAGS="-xCORE-AVX512" make

rm -r test/vtune_lab3_avx
mpiexec vtune -collect hpc-performance -r test/vtune_lab3_avx build/heart_demo -m mesh_mid -s setup_mid.txt -t 50 2>&1 > /dev/null
# mpirun -n 10 -ppn 5 -hosts art1,art2 -gtool "vtune -collect hpc-performance -r test/vtune_lab3_avx: 0-9" build/heart_demo -m mesh_mid -s setup_mid.txt -i -t 50 2>&1 > /dev/null
