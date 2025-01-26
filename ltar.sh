#!/bin/bash

source ./src/help.sh
source ./src/parameterHandler.sh
source ./src/getFilesSize.sh
source ./src/ddLoadingBar.sh
source ./src/createTarBall.sh 
source ./src/openTarBall.sh

tempDir="/tmp"

workDir="$PWD"
echo "$workDir"
files=("./testing/files")
output="./testing/test.ltar"
compression="none"
action="create"
quiet="no"

handleParams $@

if [[ "$quiet" == "true" ]]; then
    consoleOutput=/dev/null
else
    consoleOutput=/dev/tty
fi

echo $consoleOutput

echo $output

if [[ "$action" == "create" ]]; then

    echo -n "Please enter your password:" 
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

    passwordFilePath="/tmp/ltar.txt"
    touch "$passwordFilePath"
    echo "$luksPassword" > /tmp/ltar.txt

    ddOutputPath="$tempDir/ddOutput"

    # echo "$ddOutputPath"

    ddOutputSize=$(getFilesSize ${files[@]})


    # echo "$ddOutputSize"

    ddOutputSize=$(($ddOutputSize + 30000))

    cd $tempDir
    # ddLoadingBar $ddOutputPath $ddOutputSize &
    dd if=/dev/zero of="$ddOutputPath" bs="$ddOutputSize"K count=1 &> $consoleOutput 

    luksName="itar_drive"           
    mountPoint="/tmp/itar"        

    if [ ! -f "$ddOutputPath" ]; then
        echo "Die Datei $ddOutputPath existiert nicht. Bitte überprüfen Sie den Pfad."
        exit 1
    fi

    if [ ! -d "$mountPoint" ]; then
        mkdir $mountPoint
    fi

    if [ "$EUID" -ne 0 ]; then
            sudo echo -ne ""
    fi

    sudo cryptsetup luksFormat $ddOutputPath --key-file "$passwordFilePath" <<< "YES" > $consoleOutput

    sudo cryptsetup open $ddOutputPath $luksName --key-file "$passwordFilePath" > $consoleOutput

    sudo mkfs.ext4 /dev/mapper/$luksName &> $consoleOutput

    mkdir -p $mountPoint
    sudo mount /dev/mapper/$luksName $mountPoint    

    cd $workDir

    sudo cp -r "$files" "$mountPoint"

    sudo umount $mountPoint
    sudo cryptsetup close $luksName

    createTarball $compression $output $ddOutputPath
elif [[ "$action" == "extract" ]]; then

    

    tarPath="/tmp/ltar-extract"
    if [ ! -d "$tarPath" ]; then
        mkdir $tarPath
    fi

    if [ "$EUID" -ne 0 ]; then
        sudo echo -ne ""
    fi

    sudo cp "${files[0]}" $tarPath
    cd $tarPath
    openTarBall "${files[0]}" $tarPath
    cd $workDir
    echo -n "Please enter your password: "
    read -s luksPassword
    echo ""

    passwordFilePath="/tmp/ltar_temp.txt"
    touch "$passwordFilePath"

    echo $luksPassword > $passwordFilePath


    luksName="itar_drive"
    sudo cryptsetup open $tarPath/tmp/ddOutput $luksName --key-file "$passwordFilePath" 1> $consoleOutput

    mountPoint="/tmp/itar"
    mkdir -p $mountPoint
    sudo mount /dev/mapper/$luksName $mountPoint

    outputDir="$output"
    if [ ! -d "$outputDir" ]; then
        mkdir -p "$outputDir"
    fi
    sudo cp -r $mountPoint/* "$outputDir"

    sudo umount $mountPoint
    sudo cryptsetup close $luksName

    rm "$passwordFilePath"
    
fi
