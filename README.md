# Parte 1

Antes de arrancar las mvs añadimos a cada una un disco extra de 32MB

Instalamos el software necesario:

```
sudo apt install lvm2
sudo systemctl list-units
sudo apt install gdisk
sudo apt install parted
```

## Configurar disco

Configuramos las particiones del disco:

```
sudo fdisk -l
sudo gdisk nombreDisco
o
n
ENTER
ENTER
+16MB
ENTER
n
ENTER
ENTER
ENTER
ENTER
w
```

Comprobamos que el particionado es correcto:

```
sudo parted nombreDisco align-check optimal numParticionConcreta
```

## Sistemas de ficheros

Creamos los sistemas de ficheros:

```
sudo mkfs -t ext3 nombreParticion1
sudo mkfs -t ext4 nombreParticion2
```

Creamos las carpetas en media

```
cd /media
sudo mkdir ds1
sudo mkdir ds2
```

Editamos el fichero que hace que se monten:

```
sudo vi /etc/fstab
```

Añadimos al final las siguientes lineas

```
/dev/sdb1    /media/ds1  ext3   defaults 0 0
/dev/sdb2    /media/ds2  ext4   defaults 0 0
```

Guardamos el fichero, con esto indicamos las carpetas de montaje.

# Parte 2

Debemos configurar la red en virtual box cambiamos el adaptador 1 de ambas máquinas a la red host only, después en ambas máquinas:

```
sudo vi /etc/network/interfaces
```

Comentamos las lineas que definen enp0s3 y escribimos:(para la segunda máquina cambiar el 2 del address por un 3)

```
auto enp0s3
iface enp0s3 inet static
    address 192.168.58.2
    netmask 255.255.255.0
```

Guardamos y ejecutamos:

```
sudo systemctl restart networking
```

Para poder ejecutar el script antes debemos generar una llave en el host

```
ssh-keygen -b 4096 -t ed25519
```

Y mandarla a las máquinas virtuales

```
scp .ssh/id_ed25519.pub as@192.168.58.2:~/ 
scp .ssh/id_ed25519.pub as@192.168.58.3:~/
```

Desde las mv hacemos lo siguiente

```
sudo vi /etc/sudoers
```

Añadimos esta linea al final

```
as ALL=(ALL) NOPASSWD:ALL
```

Guardamos y ejecutamos

```
touch .ssh/authorized_keys
cat id_ed25519.pub >> .ssh/authorized_keys
```

Ejecutamos el script desde la máquina host
```
./parte2.sh 192.168.58.2
./parte2.sh 192.168.58.3
```
# Parte 3

Añadimos a la mv un nuevo disco virtual de 32MB

Listamos los discos para ver el nombre del nuevo

```
sudo fdisk -l
```

Creamos la partición total del nuevo disco

```
sudo gdisk /dev/sdc
o
n
ENTER
ENTER
ENTER
ENTER
w
```

Hacemos que la partición sea del tipo deseado

```
sudo parted /dev/sdc set 1 lvm on
```

Miramos la lista de nombres actuales para ver cual NO podemos usar

```
sudo vgdisplay
```

Creamos el vg

```
sudo vgcreate vg_p5 /dev/sdc1
```

Subimos el primer script de host a la maquina

```
scp vg.sh as@192.168.58.2:~/ 
```

Editamos el fichero que hace que se monten:

```
sudo vi /etc/fstab
```

Eliminamos siguientes lineas

```
/dev/sdb1    /media/ds1  ext3   defaults 0 0
/dev/sdb2    /media/ds2  ext4   defaults 0 0
```

Guardamos el fichero y ejecutamos

```
sudo shutdown -r now
```

Ejecutamos el script

```
sudo ./vg.sh vg_p5 /dev/sdb1 /dev/sdb2
```

Subimos el segundo script de host a la maquina

```
scp lv.sh as@192.168.58.2:~/ 
scp inputLV.txt as@192.168.58.2:~/ 
```

Ejecutamos el script

```
sudo ./lv.sh < inputLV.txt
```