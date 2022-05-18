#!/bin/bash
if [ $# -ne 1 ]; then 
    echo "Introduzca la IP como parámetro"
    exit 1
fi
ssh as@"$1" "sudo sfdisk -s && sudo sfdisk -l && sudo df -hT | grep -vE 'udev|tmpfs'"