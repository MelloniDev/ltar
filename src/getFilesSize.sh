#!/bin/bash

getFilesSize(){
    files=("$@")

    size=0

    for i in ${files[@]}; do
        fileSize=$(du $i | cut -f 1)

        size=$(( $size + $fileSize ))
    done

    echo $size
}