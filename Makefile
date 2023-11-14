CXXFLAGS = -g -std=c++11 -qopenmp -parallel-source-info=2
MPICXX = mpiicpc

.PHONY: clean

build/heart_demo: heart_demo.cpp luo_rudy_1991.cpp rcm.cpp mesh.cpp | build
	$(MPICXX) $(CXXFLAGS) $^ -o $@ 

build:
	mkdir build

clean:
	rm -f build/*
