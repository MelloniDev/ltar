#!/bin/bash

source ./src/help.sh
#source ./src/handleParams.sh
source ./src/getFilesSize.sh

tempDir="./testing"

files=("./testing/files")
output="./testing/test.ltar"
verbose=0
compression="none"
action="create"



echo -n "Please enter your password: "
read -s luksPassword
echo ""

echo -n "Please repeat your password: "
read -s luksPasswordVerify
echo ""

if [[ "$luksPassword" == "$luksPasswordVerify" ]]; then
    echo "$luksPassword"
else
    echo "Passwords didn't match"
fi


# handleParams $@


ddOutputPath="ddOutput"


ddOutputSize=$(getFilesSize ${files[@]})


echo "$ddOutputSize"

ddOutputSize=$(($ddOutputSize + 1000))

cd $tempDir
dd if=/dev/zero of="$ddOutputPath" bs="$ddOutputSize"K count=1
