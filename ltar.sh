#!/bin/bash

source ./src/help.sh
#source ./src/handleParams.sh
source ./src/getFilesSize.sh
source ./src/ddLoadingBar.sh

tempDir="/tmp"

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

passwordFilePath="/tmp/ltar.txt"
ddOutputPath="$tempDir/ddOutput"

# echo "$ddOutputPath"

touch "$passwordFilePath"
echo "$luksPassword" > /tmp/ltar.txt

ddOutputSize=$(getFilesSize ${files[@]})


# echo "$ddOutputSize"

ddOutputSize=$(($ddOutputSize + 1000))

cd $tempDir
ddLoadingBar $ddOutputPath $ddOutputSize &
dd if=/dev/zero of="$ddOutputPath" bs="$ddOutputSize"K count=1

luksName="itar_drive"           
mountPoint="/tmp/itar"        

if [ ! -f "$ddOutputFile" ]; then
    echo "Die Datei $ddOutputFile existiert nicht. Bitte überprüfen Sie den Pfad."
    exit 1
fi

if [ "$EUID" -ne 0 ]; then
        sudo echo -ne ""
fi

sudo cryptsetup luksFormat $ddOutputFile --key-file "$passwordFilePath"

sudo cryptsetup open $ddOutputFile $luksName --key-file "$passwordFilePath"

sudo mkfs.ext4 /dev/mapper/$luksName

mkdir -p $mountPoint
sudo mount /dev/mapper/$luksName $mountPoint    

cp "$files" "$mountPoint"

sudo unmount $mountPoint
sudo cryptsetup close $luksName

source ./src/createTarball.sh $compression $output $ddOutputPath