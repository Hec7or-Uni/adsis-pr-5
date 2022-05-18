#!/bin/bash
#798095, Toral Pallas, Hector, M, 3, B
#821259, Pizarro Martínez, Francisco Javier, M, 3, B
if [ $EUID -ne 0 ]; then
    echo "Necesitas ser admin"
    exit 1
fi
if [ $# -lt 2 ]; then 
    echo "Número de parámetros insuficiente"
    exit 1
fi
nombre=$1
shift
vgextend $nombre $@