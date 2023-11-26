MPICXX = mpiicpc
CXXFLAGS += -g -std=c++11 -qopenmp -parallel-source-info=2

.PHONY: all opt clean

build/heart_demo: heart_demo.cpp luo_rudy_1991.cpp rcm.cpp mesh.cpp | build
	$(MPICXX) $(CXXFLAGS) $^ -o $@ 

build/heart_demo_opt: heart_demo_opt.cpp luo_rudy_1991.cpp rcm.cpp mesh.cpp | build
	$(MPICXX) $(CXXFLAGS) -xCORE-AVX512 $^ -o $@ 

build:
	mkdir build

all: build/heart_demo build/heart_demo_opt

opt: build/heart_demo_opt

clean:
	rm -f build/*
