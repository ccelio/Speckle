**Purpose**:

   The goal of this repository is to help you compile and run SPEC.

**Requirements**:

   - you must have your own copy of SPEC CPU2006 v1.2. 

**Details**:

   We will compile the binaries "in vivo", calling into the actual SPEC CPU2006
   directory. Once completed, the binaries are copied into this directory (./build). 
   
   The reasoning is that compiling the benchmarks is complicated and difficult (so
   why redo that effort?), but we want better control over executing the binaries.  Of
   course, we are forgoing the validation and results building infrastructure of
   SPEC. 
   
**To compile binaries**:

   - set the $SPEC_DIR in gen_binaries.sh to point to your copy of CPU2006-1.2.
   - modify ./riscv.cfg as desired. It will get copied over to  $SPEC_DIR/configs. 
   - run gen_binaries.sh
   
**TODO**

   - specify the SPEC input mode so we can properly symlink to the input datasets.
                    
