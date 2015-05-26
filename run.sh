#!/bin/bash

TARGET_RUN="spike pk -c"
INPUT_TYPE=test # THIS MUST BE ON LINE 4 for an external sed command to work!
                # this allows us to externally set the INPUT_TYPE this script will execute

BENCHMARKS=(400.perlbench 401.bzip2 403.gcc 429.mcf 445.gobmk 456.hmmer 458.sjeng 462.libquantum 464.h264ref 471.omnetpp 473.astar 483.xalancbmk)

base_dir=$PWD
for b in ${BENCHMARKS[@]}; do

   echo " -== ${b} ==-"
   mkdir -p ${base_dir}/output

   cd ${base_dir}/${b}
   SHORT_EXE=${b##*.} # cut off the numbers ###.short_exe
   if [ $b == "483.xalancbmk" ]; then 
      SHORT_EXE=Xalan #WTF SPEC???
   fi
   
   # read the command file
   IFS=$'\n' read -d '' -r -a commands < ${base_dir}/commands/${b}.${INPUT_TYPE}.cmd

   # run each workload
   count=0
   for input in "${commands[@]}"; do
      if [[ ${input:0:1} != '#' ]]; then # allow us to comment out lines in the cmd files
         cmd="${TARGET_RUN} ${SHORT_EXE} ${input} > ${base_dir}/output/${SHORT_EXE}.${count}.out"
         echo "workload=[${cmd}]"
         eval ${cmd}
         ((count++))
      fi
   done
   echo ""

done


echo ""
echo "Done!"
