#!/bin/bash

source ./src/help.sh
source ./src/parameterHandler.sh
source ./src/getFilesSize.sh
source ./src/ddLoadingBar.sh
source ./src/createTarBall.sh 

tempDir="/tmp"

files=("./testing/files")
output="./testing/test.ltar"
compression="none"
action="create"
quiet="no"

handleParams $@


if [[ "$quiet" -eq "yes" ]]; then
    consoleOutput="/dev/null"
else
    consoleOutput="/dev/tty"
fi

echo $output

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





passwordFilePath="/tmp/ltar.txt"
ddOutputPath="$tempDir/ddOutput"

# echo "$ddOutputPath"

touch "$passwordFilePath"
echo "$luksPassword" > /tmp/ltar.txt

ddOutputSize=$(getFilesSize ${files[@]})


# echo "$ddOutputSize"

ddOutputSize=$(($ddOutputSize + 30000))

cd $tempDir
ddLoadingBar $ddOutputPath $ddOutputSize &
dd if=/dev/zero of="$ddOutputPath" bs="$ddOutputSize"K count=1

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

sudo cryptsetup luksFormat $ddOutputPath --key-file "$passwordFilePath" 1> $consoleOutput

sudo cryptsetup open $ddOutputPath $luksName --key-file "$passwordFilePath" 1> $consoleOutput

sudo mkfs.ext4 /dev/mapper/$luksName

mkdir -p $mountPoint
sudo mount /dev/mapper/$luksName $mountPoint    

cp "$files" "$mountPoint"

sudo unmount $mountPoint
sudo cryptsetup close $luksName

createTarball $compression $output $ddOutputPath