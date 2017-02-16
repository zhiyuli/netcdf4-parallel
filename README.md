# set up development environment for parallel-NetCDF4-C project

This repo contains a Eclipse (Neon.2 Release 4.6.2) C project that holds some parallel-NetCDF4-C demo codes.

# install ubuntu
Ubuntu 16.04 x64 desktop

# install mpich 3.2
sudo apt-get install mpich
which mpicc # /usr/bin/mpicc

# install dependencies
sudo apt-get install zlib1g-dev m4 build-essential

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
make check (optional)
sudo make install

# make sys aware of libs newly installed
sudo ldconfig

# install Eclipse
https://www.eclipse.org/downloads/download.php?file=/oomph/epp/neon/R2a/eclipse-inst-win64.exe

# notes:
Debug mode dynamically links .so files; Release mode statically links .a files
check executable dependency (check which zlib/libz.so linked): ldd executable_file_name

