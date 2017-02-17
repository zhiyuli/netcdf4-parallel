# Set up development environment for parallel-NetCDF4-C project

This repo contains a Eclipse (Neon.2 Release 4.6.2) C project that holds some parallel-NetCDF4-C demo codes.

# install ubuntu
Ubuntu 16.04 x64 desktop

# install mpich 3.2
sudo apt-get install mpich
which mpicc # /usr/bin/mpicc

# install dependencies
sudo apt-get install zlib1g-dev m4 build-essential

# install mpe
see: https://cs.calvin.edu/courses/cs/374/MPI/MPE/
cd ~
wget ftp://ftp.mcs.anl.gov/pub/mpi/mpe/mpe2-2.4.9b.tgz
tar xvzf mpe2-2.4.9b.tgz
cd mpe*
./configure CC=/usr/bin/gcc MPI_CC=/usr/bin/mpicc --disable-f77 --prefix=/usr/local
make -j8
sudo make install

# build szip
cd ~
wget https://support.hdfgroup.org/ftp/lib-external/szip/2.1.1/src/szip-2.1.1.tar.gz
tar xvzf szip-2.1.1.tar.gz
./configure --prefix=/usr/local
make -j8
sudo make install

# build hdf5  with parallel i/o
cd ~
wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.0-patch1/src/hdf5-1.10.0-patch1.tar
tar xvf hdf5-1.10.0-patch1.tar
# use default zlib installed by zlib1g-dev
CC=/usr/bin/mpicc ./configure --with-szlib --enable-parallel --prefix=/usr/local
make -j8
make check (optional; add -i to skip errors)
make install

# build netcdf4 with parallel i/o
cd ~
wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4.4.1.1.tar.gz
tar xvzf netcdf-4.4.1.1.tar.gz
# use default zlib installed by zlib1g-dev
CC=mpicc CPPFLAGS="-I/usr/local/include" LDFLAGS="-L/usr/local/lib" ./configure --enable-shared --enable-parallel-tests --prefix=/usr/local
make -j8
make check (optional, see below)
sudo make install
nc-config --all

# fix bug in parallel test cases: only apply to 4.4.1.1
## Add missing #include "err_macros.h" to ./h5_test/tst_h_par.c
## vi ./h5_test/tst_h_par.c
#include <nc_tests.h>
#include "err_macros.h"
#include <hdf5.h>


# make sys aware of libs newly installed
sudo ldconfig

# install Eclipse (Neon.2)
https://www.eclipse.org/downloads/

# notes:
Debug mode dynamically links .so files; Release mode statically links .a files
check executable dependency (check which zlib/libz.so linked): ldd executable_file_name

#How to compile/link a source code in commnad line
see http://www.unidata.ucar.edu/software/netcdf/docs/getting_and_building_netcdf.html#build_parallel
# Release Compile
mpicc -I/tmp/netcdf-4.4.1.1 -I/tmp/netcdf-4.4.1.1/include -O3 -Wall -c -fmessage-length=0 -MMD -MP -MF"tst_parallel4.d" -MT"tst_parallel4.o" -o tst_parallel4.o tst_parallel4.c
# Dynamic link
mpicc -o tst_parallel4 tst_parallel4.o -lnetcdf -lmpe -llmpe -pthread


# Static link 
(be use to link against the right "libz.a" used to build hdf5 
# Dynamically link to a specific libz (used to build hdf5) 
mpicc -o tst_parallel4 tst_parallel4.o /usr/local/lib/libnetcdf.a  /usr/local/lib/libhdf5_hl.a /usr/local/lib/libhdf5.a /usr/local/lib/libsz.a /usr/local/lib/libz.a /usr/local/lib/libmpe.a /usr/local/lib/liblmpe.a -ldl -lm -pthread
# Statically link to default/sys libz
mpicc -o tst_parallel4 tst_parallel4.o /usr/local/lib/libnetcdf.a  /usr/local/lib/libhdf5_hl.a /usr/local/lib/libhdf5.a /usr/local/lib/libsz.a /usr/local/lib/libmpe.a /usr/local/lib/liblmpe.a -ldl -lm -lz -pthread


