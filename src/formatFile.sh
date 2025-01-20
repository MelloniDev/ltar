#!/bin/bash

LUKS_NAME="itar_drive"           
MOUNT_POINT="/tmp/itar"        

if [ ! -f "$ddOutputFile" ]; then
    echo "Die Datei $ddOutputFile existiert nicht. Bitte überprüfen Sie den Pfad."
    exit 1
fi

if [ "$EUID" -ne 0 ]; then
    echo "Dieses Skript muss als Root ausgeführt werden."
    exit 1
fi

cryptsetup luksFormat $ddOutputFile

cryptsetup open $ddOutputFile $LUKS_NAME

mkfs.ext4 /dev/mapper/$LUKS_NAME

mkdir -p $MOUNT_POINT
mount /dev/mapper/$LUKS_NAME $MOUNT_POINT


