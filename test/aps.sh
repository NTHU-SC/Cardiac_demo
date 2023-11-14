#!/usr/bin/bash

module load compiler mpi vtune

cd ..
make

export OMP_NUM_THREADS=16
mpirun -n 10 -ppn 5 -hosts art1,art2 aps --result-dir=test/aps_result_lab2 build/heart_demo -m mesh_small -s setup_small.txt -t 15 2>&1 > /dev/null
# mpirun -n 10 -ppn 5 -hosts art1,art2 -aps build/heart_demo -m mesh_small -s setup_small.txt -t 15 2>&1 > /dev/null

cd test
aps-report aps_result_lab2
rm -rf aps_result_lab2
