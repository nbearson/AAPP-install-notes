#!/bin/ksh

if [ "$AAPP_PREFIX" = "" ]; then
  echo "Please set environment variable AAPP_PREFIX"
  exit 1
fi
if [ ! -d "$AAPP_PREFIX" ]; then
  echo "$AAPP_PREFIX is not a directory"
  exit 1
fi
if [ ! -d "$PATH_OPS" ]; then
  echo "Please define PATH_OPS: the directory containing perl script ops_process,"
  echo "e.g. export PATH_OPS=~/OPS-LRS/run_5-0+p12/OPS/perl"
  exit 1
fi
if [ ! -d "$DIR_IASICONFIG" ]; then
  echo "Please define DIR_IASICONFIG: the directory containing IASI config files"
  echo "(BRD, GRD, ODB, etc.). These can be downloaded from the AAPP ftp server."
fi

# USAGE IS NOW: ./$script M0? $indir $outdir $wrkdir
#  where M01 for metopB and M02 for metopA

. $AAPP_PREFIX/ATOVS_CONF

PAR_NAVIGATION_DEFAULT_LISTESAT=$1
PAR_NAVIGATION_DEFAULT_LISTEBUL=tle
#DIR_NAVIGATION=$PWD/orbelems

export TZ=UTC   #workaround for possible time zone problems in MISC.pm.

INDIR=$2
OUTDIR=$3
WRK=$4
mkdir -p $OUTDIR
mkdir -p $WRK

cd $WRK

rm -rf $1
time AAPP_RUN_METOP -i "AMSU-A MHS HIRS IASI AVHRR" -g " " \
          -d $INDIR -o $OUTDIR >$WRK/AAPP_RUN_METOP_IASI.out 2>$WRK/AAPP_RUN_METOP_IASI.err

if [ $? = 0 ]; then
  echo "AAPP_RUN_METOP completed, output is in '$WRK' and '$OUTDIR'"
else
  echo "AAPP_RUN_METOP failed"
fi
