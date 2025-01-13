#!/bin/bash

source ./src/help.sh
#source ./src/handleParams.sh
source ./src/getFilesSize.sh


tempDir="/tmp/ltar"

files=("./testing/files")
output="./testing/test.ltar"
verbose=0
compression="none"


# handleParams $@

ddOutputPath="$tempDir/$output"


echo $(getFilesSize ${files[@]})


