#!/bin/bash

#Detectar disco de 10GB (excluyendo sda)
DISCO=$(lsblk -o NAME,SIZE -d | grep '10G' | grep -v sda | awk '{print "/dev/"$1}')
echo "Disco detectado: $DISCO"

if [ -z "$DISCO" ]; then
    echo " No se encontró un disco de 10GB. Abortando."
    exit 1
fi

echo "reando particiones con fdisk..."

# Crear 3 particiones primarias
for i in 1 2 3; do
    echo -e "n\np\n$i\n\n+1G\nw" | sudo fdisk $DISCO
    sleep 1
done

# Crear 1 partición extendida (como 4ta)
echo -e "n\ne\n4\n\n\nw" | sudo fdisk $DISCO
sleep 1

# Crear 6 particiones lógicas dentro de la extendida
for i in {1..6}; do
    echo -e "n\nl\n\n+1G\nw" | sudo fdisk $DISCO
    sleep 1
done

# Mostrar particiones resultantes
echo "Tabla de particiones actual:"
sudo fdisk -l $DISCO

# Formatea todas las unidades
for i in {1..10}; do
    sudo mkfs.ext4 ${DISCO}${i}
    echo "Formateada: ${DISCO}${i}"
done

echo " Todas las particiones fueron formateadas en ext4"

#Monta las unidades en las carpetas correspondientes
for i in {1..9}; do
    if [ $i -le 3 ]; then
        RUTA="/Examenes-UTN/Alumno1/parcial$i"
    elif [ $i -le 6 ]; then
        num=$((i - 3))
        RUTA="/Examenes-UTN/Alumno2/parcial$num"
    else
        num=$((i - 6))
        RUTA="/Examenes-UTN/Alumno3/parcial$num"
    fi

    sudo mkdir -p "$RUTA"
    echo "${DISCO}${i} $RUTA ext4 defaults 0 2" | sudo tee -a /etc/fstab
    sudo mount "$RUTA"
    echo "Montado ${DISCO}${i} en $RUTA"
done

# Partición 10 → Profesores
RUTA="/Examenes-UTN/Profesores"

sudo mkdir -p "$RUTA"

echo "${DISCO}10 $RUTA ext4 defaults 0 2" | sudo tee -a /etc/fstab

sudo mount "$RUTA"

echo "Montado ${DISCO}10 en $RUTA"

echo "Montaje finalizado con 3 ifs: Alumno_1, Alumno2, Alumno3 y Profesores."
