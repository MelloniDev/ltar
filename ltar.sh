#!/bin/bash

source ./src/help.sh
#source ./src/handleParams.sh
source ./src/getFilesSize.sh


tempDir="./testing"

files=("./testing/files")
output="./testing/test.ltar"
verbose=0
compression="none"


# handleParams $@


ddOutputPath="ddOutput"


ddOutputSize=$(getFilesSize ${files[@]})


echo "$ddOutputSize"

ddOutputSize=$(($ddOutputSize + 1000))

cd $tempDir
dd if=/dev/zero of="$ddOutputPath" bs="$ddOutputSize"K count=1
