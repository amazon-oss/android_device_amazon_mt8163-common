#!/bin/bash

C=$(pwd)
D="bionic"

clear_patches() { cd ${C}/${1}; git checkout -- . && git clean -df; cd ${C}; }

for R in $D; do
    clear_patches $R
done
