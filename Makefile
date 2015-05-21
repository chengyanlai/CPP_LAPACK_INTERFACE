
ifeq "$(ARCH)" ""
ARCH = x86_64
endif

ifeq "$(OS)" ""
OS = $(shell uname -s)
endif

ifeq ("$(OS)", "Darwin")
	LIBFLAG = OSX
	CXX = clang++ -O3 -m64 -std=c++11 -stdlib=libc++ -I./# -DCOMPLEX_MATRIX_ELEMENS
	LAPACK = -lblas -llapack -lm
else ifeq ("$(OS)", "Linux")
	LIBFLAG = MKL
	CXX = icpc -O3 -Wall -std=c++0x -I./ -DMKL# -DCOMPLEX_MATRIX_ELEMENS
	MKLROOT= /data2/intel/composer_xe_2015.2.164/mkl
	LAPACK = $(MKLROOT)/lib/intel64/libmkl_blas95_lp64.a  $(MKLROOT)/lib/intel64/libmkl_lapack95_lp64.a  -Wl,--start-group  $(MKLROOT)/lib/intel64/libmkl_intel_lp64.a \
	$(MKLROOT)/lib/intel64/libmkl_sequential.a $(MKLROOT)/lib/intel64/libmkl_core.a -Wl,--end-group -lpthread -lm
endif

CF := gfortran -O3

all:cpp.e

cpp.e: main.o
	$(CXX) -o $@ $< myLapack.o $(LAPACK)

main.o: dsyev_example.cpp myLapack.o
	$(CXX) -o $@ -c $<

myLapack.o: myLapack.cpp
	$(CXX) -D${LIBFLAG} -o $@ -c $<

f95.e: main95.o
	$(CF) -o $@ $< myLapack95.o nrtype.o $(LAPACK)

main95.o: dsyev_example.f90 myLapack95.o nrtype.o
	$(CF) -x f95-cpp-input -o $@ -c $<

myLapack95.o: myLapack95.f90 nrtype.o
	$(CF) -x f95-cpp-input -D${LIBFLAG} -o $@ -c $<

nrtype.o: nrtype.f90
	$(CF) -x f95-cpp-input -o $@ -c $<

clean:
	rm -f *.o *.mod *.e

.PHONY : clean
