#!/bin/bash

#############
# TODO
# handle test, training, and ref input sets
# cmds/401.bzip2.test.cmd

if [ -z  "$SPEC_DIR" ]; then 
   echo "  Please set the SPEC_DIR environment variable to point to your copy of SPEC CPU2006."
   exit 1
fi

CONFIGFILE=riscv.cfg
RUN="spike pk -c "
CMD_FILE=commands.txt

# the integer set
BENCHMARKS=(401.bzip2)
#BENCHMARKS=(400.perlbench 401.bzip2 403.gcc 429.mcf 445.gobmk 456.hmmer 458.sjeng 462.libquantum 464.h264ref 471.omnetpp 473.astar 483.xalancbmk)

# idiomatic parameter and option handling in sh
compileFlag=false
runFlag=false
while test $# -gt 0
do
   case "$1" in
        --compile) 
            compileFlag=true
            ;;
        --run) 
            runFlag=true
            ;;
        --*) echo "ERROR: bad option $1"
            exit 1
            ;;
        *) echo "ERROR: bad argument $1"
            exit 2
            ;;
    esac
    shift
done

echo "== Speckle Options =="
echo "  compile: " $compileFlag
echo "  run    : " $runFlag
echo ""


BUILD_DIR=$PWD/build
mkdir -p build;

# compile the binaries
if [ "$compileFlag" = true ]; then
   echo "Compiling SPEC... but only TEST INPUT! [TODO]"
   rm -f $BUILD_DIR/$CMD_FILE # we'll rebuild this from the SPEC control files
   # copy over the config file we will use to compile the benchmarks
   cp $BUILD_DIR/../${CONFIGFILE} $SPEC_DIR/config/${CONFIGFILE}
#   cd $SPEC_DIR; . ./shrc; time runspec --config riscv --size test --action scrub int
   cd $SPEC_DIR; . ./shrc; time runspec --config riscv --size test --action setup bzip2
#   cd $SPEC_DIR; . ./shrc; time runspec --config riscv --size test --action setup int
#   cd $SPEC_DIR; . ./shrc; time runspec --config riscv --size train --action setup int
#   cd $SPEC_DIR; . ./shrc; time runspec --config riscv --size ref --action setup int

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

      echo "ln -s $BMK_DIR $BUILD_DIR/${b}_test"
      ln -sf $BMK_DIR $BUILD_DIR/${b}_test

      # read the control file
      cd $BUILD_DIR/${b}_test
      IFS=$'\n' read -d '' -r -a commands < control

      # build command file
      for input in "${commands[@]}"; do
         echo "cd $PWD;" ${RUN} ${SHORT_EXE}_base.riscv64 ${input} >> $BUILD_DIR/$CMD_FILE
      done
   done
fi

# running the binaries/building the command file
# we could also just run through BUILD_DIR/CMD_FILE and run those...
if [ "$runFlag" = true ]; then

   for b in ${BENCHMARKS[@]}; do
   
      cd $BUILD_DIR/${b}_test
      SHORT_EXE=${b##*.} # cut off the numbers ###.short_exe
      if [ $b == "483.xalancbmk" ]; then 
         SHORT_EXE=Xalan #WTF SPEC???
      fi
      
      # read the control file
      IFS=$'\n' read -d '' -r -a commands < control
      #IFS=$'\n' read -d '' -r -a commands < commands/${b}.test.cmd 

      CMD_FILE=${BUILD_DIR}/../commands.txt
      for input in "${commands[@]}"; do
         echo "Running " ${b} ${input} " ... "
         # build command file
         ${RUN} ${SHORT_EXE}_base.riscv64 ${input} 
      done
   
   done

fi

echo "Done!"
