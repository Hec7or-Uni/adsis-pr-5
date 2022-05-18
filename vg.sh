#!/bin/bash
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