#!/bin/sh
# script for execution of deployed applications
#
# Sets up the MCR environment for the current $ARCH and executes
# the specified command.
#
# This script has been modified for deployment of the application
#  "ContraX"
#
# M. A. Hopcroft, hopcroft@ucsb.edu
#

app_name="ContraX"
MCRVER="v911"
MATLABVER="R2021b"

# Set the screen size to match the application window
printf '\e[8;30;100t'
echo " "
echo "Starting ${app_name}"
echo " Brought to you by the Microsystems Lab at UCSB"
echo "  https://pruittlab.engineering.ucsb.edu"
echo "----"
exe_name=$0
exe_dir=`dirname "$0"`
cd "$exe_dir"
#cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd;

#echo "------------------------------------------"
#if [ "x$1" = "x" ]; then
#  echo Usage:
#  echo    $0 \<deployedMCRroot\> args
#else
  echo "Setting up environment variables"

  #MCRROOT="$1"
  if [ -d "/Applications/MATLAB/MATLAB_Compiler_Runtime/${MCRVER}" ] ; then
  	echo "Using MCR v9.11 ($MATLABVER) (_Compiler)"
  	MCRROOT=/Applications/MATLAB/MATLAB_Compiler_Runtime/${MCRVER}

  elif [ -d "/Applications/MATLAB/MATLAB_Runtime/${MCRVER}" ] ; then
  	echo "Using MCR v9.11 ($MATLABVER)"
  	MCRROOT=/Applications/MATLAB/MATLAB_Runtime/${MCRVER}

  elif [ -d "/Applications/MATLAB_${MATLABVER}.app" ] ; then
  	echo "Using MATLAB $MATLABVER application"
  	MCRROOT=/Applications/MATLAB_R2021b.app

  else
  	echo "No MATLAB libraries found! Install MCR $MATLABVER from:"
  	echo " https://www.mathworks.com/products/compiler/matlab-runtime.html"
  	echo " "
  	sleep 10
  	exit
  fi

  DYLD_LIBRARY_PATH=.:${MCRROOT}/runtime/maci64 ;
  DYLD_LIBRARY_PATH=${DYLD_LIBRARY_PATH}:${MCRROOT}/bin/maci64 ;
  DYLD_LIBRARY_PATH=${DYLD_LIBRARY_PATH}:${MCRROOT}/sys/os/maci64;
  DYLD_LIBRARY_PATH=${DYLD_LIBRARY_PATH}:${MCRROOT}/extern/bin/maci64;
  export DYLD_LIBRARY_PATH;

  echo DYLD_LIBRARY_PATH is ${DYLD_LIBRARY_PATH};
  echo "----"
  echo "Starting application..."
  echo " "

  # disable color in ls command output
  unset CLICOLOR;
  shift 1
  args=
  while [ $# -gt 0 ]; do
      token=$1
      args="${args} \"${token}\""
      shift
  done
  eval "\"${exe_dir}/${app_name}.app/Contents/MacOS/${app_name}\"" $args
#fi
exit
