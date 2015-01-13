#!/bin/bash

#############
# TODO
# handle test, training, and ref input sets
# no way to auto-handle inputs from "controls" file? just hardcode commands myself then. i'll make my own control file?
# cmds/401.bzip2.test.cmd

${SPEC_DIR:?"Please set the SPEC_DIR environment variable to point to your copy of SPEC CPU2006."}

CONFIGFILE?=riscv.cfg

#CMD_FILE=$PWD/commands.txt
#CMD_DIR=$PWD/commands/

# the integer set
#BENCHMARKS=(401.bzip2)
BENCHMARKS=(400.perlbench 401.bzip2 403.gcc 429.mcf 445.gobmk 456.hmmer 458.sjeng 462.libquantum 464.h264ref 471.omnetpp 473.astar 483.xalancbmk)

BUILD_DIR=$PWD/build
mkdir -p build;

# compile the binaries
if [ "$1" = "compile" ]; then
   echo "Compiling SPEC... but only TEST INPUT! [TODO]"
   # copy over the config file we will use to compile the benchmarks
   cp $BUILD_DIR/../${CONFIGFILE} $SPEC_DIR/config/${CONFIGFILE}
#   cd $SPEC_DIR; . ./shrc; time runspec --config riscv --size test --action scrub int
   cd $SPEC_DIR; . ./shrc; time runspec --config riscv --size test --action setup int
#   cd $SPEC_DIR; . ./shrc; time runspec --config riscv --size train --action setup int
#   cd $SPEC_DIR; . ./shrc; time runspec --config riscv --size ref --action setup int
fi



# copy back over the binaries.  Fuck xalancbmk for being different.
# Do this for each input type.
# assume the CPU2006 directories are clean. I've hard-coded the directories I'm going to copy out of
for b in ${BENCHMARKS[@]}; do
   echo ${b}
   SHORT_EXE=${b##*.} # cut off the numbers ###.short_exe
   if [ $b == "483.xalancbmk" ]; then 
      SHORT_EXE=Xalan #WTF SPEC???
   fi
   BMK_DIR=$SPEC_DIR/benchspec/CPU2006/$b/run/run_base_test_riscv64.0000;
   
   echo "ls $SPEC_DIR/benchspec/CPU2006/$b/run"
   ls $SPEC_DIR/benchspec/CPU2006/$b/run
#   cp $BMK_DIR/${SHORT_EXE}_base.riscv64 $BUILD_DIR/$b

   echo "ln -s $BMK_DIR $BUILD_DIR/${b}_test"
   ln -sf $BMK_DIR $BUILD_DIR/${b}_test
  
   # now copy in ref
   #BMK_DIR=$SPEC_DIR/benchspec/CPU2006/$b/run/run_base_ref_riscv64.0000;
   #ln -s $BMK_DIR $BUILD_DIR/${b}_ref

   # symlink in all of the data and input files needed to run the benchmarks
   #for file in $BMK_DIR/*; do 
   #   #echo $file
   #   #echo $(basename $file)
   #   if [ $(basename $file) != $b ]; then
   #      ln -s $file $BUILD_DIR/$(basename $file)
   #   fi 
   #done
   
done

#for b in ${BENCHMARKS[@]}; do
#
#   cd $BUILD_DIR/${b}_test
#   SHORT_EXE=${b##*.} # cut off the numbers ###.short_exe
#   if [ $b == "483.xalancbmk" ]; then 
#      SHORT_EXE=Xalan #WTF SPEC???
#   fi
#   
#   # read the control file
#   IFS=$'\n' read -d '' -r -a commands < control
#   
#   for input in "${commands[@]}"; do
#      echo ${input}
#      echo "cd $PWD;" spike pk -c ${SHORT_EXE}_base.riscv64 ${input} >> $CMD_FILE
#   done
#
#done
