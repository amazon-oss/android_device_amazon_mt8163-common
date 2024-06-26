#!/bin/bash

C=$(pwd)
S="amazon/mt8163-common"
D="bionic"

apply_patches() { cd ${C}/${1}; git apply --ignore-whitespace ${C}/device/${S}/patches/$1/*.patch; cd ${C}; }

for R in $D; do
    apply_patches $R
done
