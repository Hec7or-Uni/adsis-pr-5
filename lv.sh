#!/bin/bash
# Invocar con la información así
# "nombreGrupoVolumen,nombreVolumenLogico,tamaño,tipoSistemaFicheros,directorioMontaje"

if [ $EUID -ne 0 ]; then 
    echo "Necesita ser admin"
    exit 1
fi

while IFS= read -r linea 
do
    IFS=, ; read -r nombreG nombreV tam Ficheros Montaje <<< "$linea"
    direccion=$(lvdisplay "${nombreG}/${nombreV}" -Co "lv_path" | grep "${nombreG}/${nombreV}" | tr -d ' ') &> /dev/null
    if [ -z "$direccion" ]
    then
        echo "El volumen introducido ${nombreV} no existe, va a ser creado..."
        lvcreate -n ${nombreV} -L ${tam} ${nombreG}
        if [ $? -eq 0 ]
        then
            mkdir -p "${Montaje}"
            direccion=$(lvdisplay "${nombreG}/${nombreV}" -Co "lv_path" | grep "${nombreG}/${nombreV}" | tr -d '[[:space:]]')
            echo -e "$direccion\t${Montaje}\t${Ficheros}\tdefaults 0 0" >> /etc/fstab
            mkfs.${Ficheros} $direccion && mount $direccion ${Montaje}
        fi
    else
        echo "Ya existe el volumen, se va a ampliar"
        lvextend -L ${tam} $direccion && resize2fs $direccion
    fi
done