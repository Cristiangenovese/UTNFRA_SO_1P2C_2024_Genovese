#!/bin/bash

# Crear grupos
sudo groupadd p1c2_2024_gAlumno
sudo groupadd p1c2_2024_gProfesores

# Crear usuarios con grupo correspondiente
for i in A1 A2 A3; do
  sudo useradd -m -g p1c2_2024_gAlumno p1c2_2024_$i
done

sudo useradd -m -g p1c2_2024_gProfesores p1c2_2024_P1

# Asignar permisos y dueños a cada carpeta
sudo chown p1c2_2024_A1:p1c2_2024_A1 /Examenes-UTN/Alumno1
sudo chmod 750 /Examenes-UTN/Alumno1

sudo chown p1c2_2024_A2:p1c2_2024_A2 /Examenes-UTN/Alumno2
sudo chmod 760 /Examenes-UTN/Alumno2

sudo chown p1c2_2024_A3:p1c2_2024_A3 /Examenes-UTN/Alumno3
sudo chmod 700 /Examenes-UTN/Alumno3

sudo chown p1c2_2024_P1:p1c2_2024_gProfesores /Examenes-UTN/Profesores
sudo chmod 755 /Examenes-UTN/Profesores

# Crear archivo validar.txt en cada carpeta usando el usuario correspondiente
echo "Generando archivos validar.txt..."

sudo su -c "whoami > /Examenes-UTN/Alumno1/validar.txt" p1c2_2024_A1
sudo su -c "whoami > /Examenes-UTN/Alumno2/validar.txt" p1c2_2024_A2
sudo su -c "whoami > /Examenes-UTN/Alumno3/validar.txt" p1c2_2024_A3
sudo su -c "whoami > /Examenes-UTN/Profesores/validar.txt" p1c2_2024_P1
