#!/usr/bin/bash

module load compiler mpi vtune

cd ..
make

export OMP_NUM_THREADS=16
mpirun -n 10 -ppn 5 -hosts art1,art2 -gtool "vtune -collect hpc-performance -r test/vtune_lab4: 0-9" build/heart_demo -m mesh_mid -s setup_mid.txt -i -t 50 2>&1 > /dev/null

make opt

mpirun -n 10 -ppn 5 -hosts art1,art2 -gtool "vtune -collect hpc-performance -r test/vtune_lab4_omp: 0-9" build/heart_demo_opt -m mesh_mid -s setup_mid.txt -i -t 50 2>&1 > /dev/null
