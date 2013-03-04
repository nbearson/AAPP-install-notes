Installing AAPP
===============

Tested on dragon - el6.x86_64


Install Dependencies
--------------------

Following assumes we're installing all dependencies in $HOME/opt

### JASPER - http://www.ece.uvic.ca/~frodo/jasper/
```bash
./configure --prefix=$HOME/opt
make
make install
```

### GRIBAPI - http://www.ecmwf.int/products/data/software/grib_api.html
```bash
./configure --prefix=$HOME/opt --with-jasper=$HOME/opt
make
make install
```

### BUFRDC - http://www.ecmwf.int/products/data/software/bufr.html
First line in tables_tools/check_tables.sh assumes `/usr/bin/sh`
changed it to `/usr/bin/env sh`

```bash
./build_library
     use gfortran
     don't use 64 bit reals (makes lib named libbufrR64)
     install to $HOME/opt/lib
./install
```

### HDF5 - http://www.hdfgroup.org/HDF5/
```bash
used linux 2.6 shared libs from hdfgroup site, copied subdirs into matching $HOME/opt directories
```


Building AAPP
-------------

Get the AAPP code from: ftp://ftp.metoffice.gov.uk/, must register to get a username and password.

* Get 7.1/AAPP_7.1.tgz and extract it. Then put the following script in AAPP_7 and run it:

```bash
#!/usr/bin/env sh

hdf=$HOME/opt
bufr=$HOME/opt
grib_api=$HOME/opt
jasper=$HOME/opt

INSTALLTO=$HOME/AAPP_runtime  # This is where AAPP will be installed, can be anywhere

[[ $LD_LIBRARY_PATH = *${hdf}* ]] ||
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${hdf}/lib

./configure --prefix=$INSTALLTO --fortran-compiler=gfortran --site-id=UWM \
  --external-libs="-L$bufr/lib -lbufr -L$grib_api/lib -lgrib_api_f77
-lgrib_api_f90 -lgrib_api -L$jasper/lib -ljasper -L$hdf/lib -lhdf5" \
  --external-includes="-I$hdf/include -I$grib_api/include"
```

* Copy 7.2/AAPP_update_7_2.tgz into AAPP_7, extract in place.

* Copy 7.3/AAPP_update_7_3.tgz into AAPP_7, extract in place.

* Do the same with any further updates, 7.4 is on the horizon.

* Run `make install`


Installing OPS-LRS for IASI Processing
--------------------------------------

* Grab OPS-LRS from the same FTP site as AAPP

* Build the two libraries in external_libs:
```bash
echo "Installing xerces..."
tar zxvf xerces-c-src1_7_0.tar.gz
cp iostream.h UnixHTTPURLInputStream.cpp xerces-c-src1_7_0/src/xercesc/util/NetAccessors/Socket/.
cd xerces-c-src1_7_0/
export XERCESCROOT=$PWD
cd src/xercesc
sh runConfigure -p linux -c gcc -x g++ -r pthread -P $HOME/opt
make ; make install
cd ..
echo "Installing fftw..."
tar xzvf fftw-3.0.1.tgz
cd fftw-3.0.1
./configure --prefix=$HOME/opt
make; make install
```

* Install OPS-LRS itself.

  Change back to a directory with the OPS-LRS code, ie:
  OPS-LRS/OPS-LRS_V6-0+p12/, then run the following (note the 
  site-id used below is likely incorrect)

  ```bash
  tar xzf OPS_V6-0+p12-AAPP-sl-20120618.tgz
  cd OPS_V6-0+p12-AAPP-sl-20120618
  ./configure --aapp-prefix=$HOME/AAPP --xrcs-prefix=$HOME/opt \
  --fftw-prefix=$HOME/opt --arch=Linux-gfortran --prefix=$HOME/opt --site-id=UWM \
  --nthreads=2
  make; make install
  ```


AAPP Config Notes
-----------------

Two notes from AAPP itself:

* If your  station is not contained in the station list file,
AAPP/src/navigation/libnavtool/stations.txt, you can edit and update the file
if necessary before you go on to build AAPP.

* The "station", "station_id", "tle_user" and "tle_password" options are
optional. The values that you enter are stored in the ATOVS_ENV7 file (see
section 3.6); you may edit this file later if you want to change the values.


TLE Config
----------

To use the new beta space-track.org, change this variable in ATOVS_ENV7:

```
PAR_NAVIGATION_TLE_URL_DOWNLOAD='https://beta.space-track.org'
```


METOP Config
------------

From http://www.nwpsaf.eu/forum/viewtopic.php?f=15&t=137, this may not be
necessary in versions after 7.3

1. Edit ATOVS_ENV7 to look like:
```
PAR_NAVIGATION_DEFAULT_LISTESAT=${PAR_NAVIGATION_DEFAULT_LISTESAT:='noaa19
noaa18 noaa17 noaa16 noaa15 M04 M02 M01'}
PAR_NAVIGATION_DEFAULT_LISTEBUL=${PAR_NAVIGATION_DEFAULT_LISTEBUL:='tle tle
tle tle tle tle tle tle'}
```

2. $AAPP_PREFIX/AAPP/src/calibration/libmhscl/mhs_clparams.dat: At line 403,
change the instrument ID from 105 to 5. Then "make dat".

3. $AAPP_PREFIX/AAPP/src/decommutation/libdecom/amshdu.F: Change line 149 to:
```
      DATA INSTID_MHS_METOP/5,3,4,77/     !Instrument IDs for METOP
```
then `make lib`. Go to directory $AAPP_PREFIX/metop-tools/src/bin and `make
clean; make bin`

4. Backup any ATOVS_ENV7 changes and run `make install` from the base AAPP to install these changes



