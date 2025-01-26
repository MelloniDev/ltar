#!/bin/bash

ddLoadingBar(){

    ddFile=$1
    targetSize=$2

    echo "$ddFile"

    ddFileSize=0

    while [[ ! $ddFileSize -eq $targetSize ]]; do

        percent=$(( ( $ddFileSize * 1000 / $targetSize * 1000 ) / 10000 ))

        echo "$percent"

        ddFileSize=$(du -k $ddFile | cut -f 1)
    done


}