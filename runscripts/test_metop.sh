#! /usr/bin/env sh

export AAPP_PREFIX=$HOME/AAPP
export LD_LIBRARY_PATH=$HOME/opt/lib

export PATH_OPS=$HOME/opt/OPS-LRS-run/OPS/perl
export DIR_IASICONFIG=$HOME/AAPPbuild/OPS-LRS/aux_data


### Our metopa data for test:
./run_iasi_OPS.sh M02 `pwd`/metopa `pwd`/metopa_out `pwd`/metopa_work


# Our metopb data for test:
./run_iasi_OPS.sh M01 `pwd`/metopb `pwd`/metopb_out `pwd`/metopb_work
