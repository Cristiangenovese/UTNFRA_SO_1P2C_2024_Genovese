#!/bin/bash

PARTICION=$(lsblk -o NAME,SIZE -d | grep "10G" | grep -v sda | awk '{print "/dev/"$1}')

for i in {1..10}; do
echo -e "n\np\n$i\n\n+1G\nw" | sudo fdisk $PARTICION
done

echo "Tabla de particiones"
sudo fdisk -l $PARTiCION

