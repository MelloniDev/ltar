#!/bin/bash
openTarball(){
    inputFile=$1
    outputFolder=$2
    tar -xf "$inputFile" "$outputFolder"
}
