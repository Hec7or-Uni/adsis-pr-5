#!/bin/bash
#798095, Toral Pallas, Hector, M, 3, B
#821259, Pizarro Martínez, Francisco Javier, M, 3, B
if [ $# -ne 1 ]; then 
    echo "Introduzca la IP como parámetro"
    exit 1
fi
ssh as@"$1" "sudo sfdisk -s && sudo sfdisk -l && sudo df -hT | grep -vE 'udev|tmpfs'"