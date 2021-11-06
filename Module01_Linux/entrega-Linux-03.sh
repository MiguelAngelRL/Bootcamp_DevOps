#!/bin/bash

# Creamos los directorios
mkdir -p ./foo/dummy ./foo/empty

# Cambiamos el working dir
cd ./foo/dummy

# Si no recibo parametro, harcodeamos el contenido a guardar en el fichero
[ -z "$1" ] && TEXT="Que me gusta la bash!!!!" || TEXT=$1

# Guardamos contenido en el file1,  redireccionando la salida del comando echo
echo $TEXT > file1.txt

# Creamos el file2 vacío
touch file2.txt

# Copiamos el contenido de file1 en file2, redireccionando salido del comando cat
cat file1.txt > file2.txt

# Movemos el file2 de carpeta
mv file2.txt ../empty
