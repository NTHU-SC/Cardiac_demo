#!/usr/bin/bash

module load compiler mpi

cd ..
make

cd build

echo "160 MPI processes, 1 OpenMP thread"
export OMP_NUM_THREADS=1
time mpirun -n 160 -ppn 80 -hosts art1,art2 ./heart_demo -m ../mesh_small -s ../setup_small.txt -t 15 2>&1 > /dev/null

echo "40 MPI processes, 4 OpenMP thread"
export OMP_NUM_THREADS=4
time mpirun -n 40 -ppn 20 -hosts art1,art2 ./heart_demo -m ../mesh_small -s ../setup_small.txt -t 15 2>&1 > /dev/null

echo "10 MPI processes, 16 OpenMP thread"
export OMP_NUM_THREADS=16
time mpirun -n 10 -ppn  5 -hosts art1,art2 ./heart_demo -m ../mesh_small -s ../setup_small.txt -t 15 2>&1 > /dev/null
