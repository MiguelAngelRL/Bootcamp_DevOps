#!/bin/bash

# Si no recibimos parámetro de búsqueda, terminamos el script
if [ $# -eq 0 ]
  then
    echo "Nothing to search"
    exit 1
fi

# Guardamos la respuesta en el fichero response.txt
curl -L -s https://www.google.es -o response.txt

# Efectuamos la busqueda en el fichero y mostramos sólo el número de línea en el que aparece
grep -n -a "$1" response.txt | cut -f1 -d:
