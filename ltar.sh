#!/bin/bash

source ./src/help.sh
#source ./src/handleParams.sh


tempDir="/tmp/ltar"

files=("./testing/files")
output="./testing/test.ltar"
verbose=0


handleParams $@



