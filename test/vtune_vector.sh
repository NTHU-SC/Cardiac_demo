#!/usr/bin/bash

module load compiler mpi vtune

cd ..
make

export OMP_NUM_THREADS=16
mpirun -n 10 -ppn 5 -hosts art1,art2 -gtool "vtune -collect hpc-performance -r test/vtune_lab3: 0-9" build/heart_demo -m mesh_mid -s setup_mid.txt -i -t 50 2>&1 > /dev/null
# mpirun -n 10 -ppn 5 -hosts art1,art2 vtune -collect hpc-performance -r test/vtune_lab3 build/heart_demo -m mesh_mid -s setup_mid.txt -i -t 50 2>&1 > /dev/null

make clean
CXXFLAGS="-xCORE-AVX512" make

mpirun -n 10 -ppn 5 -hosts art1,art2 -gtool "vtune -collect hpc-performance -r test/vtune_lab3_avx: 0-9" build/heart_demo -m mesh_mid -s setup_mid.txt -i -t 50 2>&1 > /dev/null
