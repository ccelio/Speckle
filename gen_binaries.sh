#!/bin/bash

# required for building and copying over binaries
SPEC_DIR=/scratch/celio/cpu2006-1.2

# the integer set
#BENCHMARKS=(400.perlbench 401.bzip2)
BENCHMARKS=(400.perlbench 401.bzip2 403.gcc 429.mcf 445.gobmk 456.hmmer 458.sjeng 462.libquantum 464.h264ref 471.omnetpp 473.astar 483.xalancbmk)

THIS_DIR=$PWD
# compile the binaries
#cd $SPEC_DIR; . ./shrc; time runspec --config riscv --size test --action scrub int
#cd $SPEC_DIR; . ./shrc; time runspec --config riscv --size test --action setup int

# copy over the config file we used to compile the benchmarks
for b in ${BENCHMARKS[@]}; do
   echo ${b}
   BMK_DIR=$SPEC_DIR/benchspec/CPU2006/$b/run/run_base_test_riscv64.0000/;
   #cd $BMK_DIR; ls
   SHORT_EXE=${b##*.} # cut off the numbers ###.short_exe
   if [ $b == "483.xalancbmk" ]
      then 
         echo "something happened"
         ls $BMK_DIR
         cp $BMK_DIR/Xalan_base.riscv64 $THIS_DIR/$b
      else
         cp $BMK_DIR/${SHORT_EXE}_base.riscv64 $THIS_DIR/$b
   fi
         

   
done
#cd $THIS_DIR; cp $SPEC_DIR/config/riscv.cfg ./riscv.cfg

