# fortran compiler
FC   = /cfs/klemming/nobackup/t/tada/pgi/linux86-64/18.4/mpi/openmpi-2.1.2/bin/mpif90
#
BIG := # -mcmodel=medium
DBG := # -g -fbacktrace -Wall -O0 -Wextra -pedantic -fcheck=all
OMP := #-openmp
OPT := -O3
OTH := -DDEBUG -DTIMING #-DIMPDIFF
PROF := #-pg
FFLAGS := -cpp $(OPT) $(BIG) $(DBG) $(PROF) $(OMP) $(OTH) -Mcuda=lineinfo -Mcuda=cc3x -Minfo=all -Mneginfo=all -gopt # -v 

#
TARGET = cans
#
OBJ = bound.o chkdiv.o chkdt.o common_mpi.o common_cuda.o correc.o debug.o fft.o fftw.o fillps.o initflow.o initgrid.o initmpi.o initsolver.o load.o main.o mom.o momd.o moms.o output.o param.o rk.o sanity.o solver.o decomp_2d.o io.o
#
#LIBS = -lfftw3 -lfftw3_threads
#LIBS = -lfftw3 -lfftw3_threads -L/opt/cray/libsci/13.0.1/GNU/49/haswell/lib #-lsci_gnu_49
LIBS = -L/pdc/vol/fftw/3.3.4/gcc/8.4/openmpi/1.8/double/lib/ -I/pdc/vol/fftw/3.3.4/gcc/8.4/openmpi/1.8/double/include -lfftw3 -I/pdc/vol/fftw/3.3.4/gcc/8.4/threads/include -L/pdc/vol/fftw/3.3.4/gcc/8.4/threads/lib/ -lfftw3_threads -lblas -llapack #-L/pdc/vol/cuda/cuda-8.0/lib64/ -lnvToolsExt
#
all: $(TARGET)
#
$(TARGET): $(OBJ)
	$(FC) $(FFLAGS) $(OPT) $(OBJ) $(LIBS) -o $(TARGET)
#
.PHONY: clean
clean:
	rm -rf *.o *.mod *dSYM $(TARGET)
#
bound.o: bound.f90 common_mpi.o
	$(FC) $(FFLAGS) -c  bound.f90 
chkdiv.o: chkdiv.f90 common_mpi.o
	$(FC) $(FFLAGS) -c  chkdiv.f90 
chkdt.o: chkdt.f90 common_mpi.o
	$(FC) $(FFLAGS) -c  chkdt.f90 
common_mpi.o: common_mpi.f90 param.o
	$(FC) $(FFLAGS) -c  common_mpi.f90 
common_cuda.o: common_cuda.cuf 
	$(FC) $(FFLAGS) -c  common_cuda.cuf
correc.o: correc.f90
	$(FC) $(FFLAGS) -c  correc.f90 
debug.o: debug.f90 common_mpi.o
	$(FC) $(FFLAGS) -c  debug.f90 
fillps.o: fillps.f90
	$(FC) $(FFLAGS) -c  fillps.f90
fft.o: fft.f90 common_mpi.o fftw.o
	$(FC) $(FFLAGS) -c  fft.f90
fftw.o: fftw.f90
	$(FC) $(FFLAGS) -c  fftw.f90
initflow.o: initflow.f90 common_mpi.o decomp_2d.o
	$(FC) $(FFLAGS) -c  initflow.f90 
initgrid.o: initgrid.f90 param.o
	$(FC) $(FFLAGS) -c  initgrid.f90 
initmpi.o: initmpi.f90 decomp_2d.o common_mpi.o
	$(FC) $(FFLAGS) -c  initmpi.f90
initsolver.o: initsolver.f90 common_mpi.o fft.o param.o
	$(FC) $(FFLAGS) -c  initsolver.f90 
load.o: load.f90 common_mpi.o decomp_2d.o io.o
	$(FC) $(FFLAGS) -c  load.f90 
main.o: main.f90 bound.o chkdiv.o chkdt.o debug.o fft.o fillps.o initflow.o initflow.o initgrid.o initmpi.o initsolver.o load.o output.o param.o rk.o sanity.o solver.o out1d.h90 out2d.h90 out3d.h90
	$(FC) $(FFLAGS) -c  main.f90
#mom.o: mom.f90 common_mpi.o
#	$(FC) $(FFLAGS) -c  mom.f90
mom.o: mom.cuf common_mpi.o
	$(FC) $(FFLAGS) -c  mom.cuf
momd.o: momd.f90 common_mpi.o
	$(FC) $(FFLAGS) -c  momd.f90
moms.o: moms.f90
	$(FC) $(FFLAGS) -c  moms.f90
output.o: output.f90 io.o
	$(FC) $(FFLAGS) -c  output.f90
param.o: param.f90 setup.h90 bc.h90
	$(FC) $(FFLAGS) -c  param.f90
#rk.o: rk.f90 debug.o mom.o momd.o moms.o param.o
#	$(FC) $(FFLAGS) -c  rk.f90
rk.o: rk.cuf debug.o mom.o momd.o moms.o param.o
	$(FC) $(FFLAGS) -lnvToolsExt -c  rk.cuf
sanity.o: sanity.f90 bound.o chkdiv.o common_mpi.o correc.o debug.o decomp_2d.o fft.o fillps.o initflow.o initmpi.o initsolver.o param.o solver.o
	$(FC) $(FFLAGS) -c  sanity.f90
solver.o: solver.f90 fft.o param.o
	$(FC) $(FFLAGS) -c  solver.f90
#
FFLAGS_2DECOMP := -DDOUBLE_PREC# -DOVERWRITE -DEVEN
2decompdir=2decomp/
decomp_2d.o: $(2decompdir)decomp_2d.f90
	$(FC) $(FFLAGS) $(FFLAGS_2DECOMP) -c $(2decompdir)decomp_2d.f90
io.o: $(2decompdir)io.f90 decomp_2d.o
	$(FC) $(FFLAGS) $(FFLAGS_2DECOMP) -c $(2decompdir)io.f90
