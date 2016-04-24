#!/bin/bash

# Nombre : ejercicio1.sh
# Autor  : Eduardo Roldán Pijuán.

# Variables de formateo de texto.
n='\e[m'
N='\e[1m'
S='\e[4m'
R='\e[31m'
# Función que se ejecuta cuando hay un error en los parámetros y muestra la ayuda.
function error_ayuda() {
    case $1 in
        0)
            echo -e "${R}${N}[Error]${n} - La sintaxis del programa es:\n\n\t${N}\
./ejercicio1.sh directorio <bytes>${n}\n\n${N}directorio${n} : Directorio sobre e\
l que trabajar (${S}obligatorio${n}).\n${N}bytes${n}      : Número mínimo de byte\
s (${S}opcional${n}).\n" >&2
            ;;
        1)
            echo -e "${R}${N}[Error]${n} - Bytes debe ser un número.\n\nLa sintax\
is del programa es:\n\n\t${N}./ejercicio1.sh directorio <bytes>${n}\n\n${N}direct\
orio${n} : Directorio sobre el que trabajar (${S}obligatorio${n}).\n${N}bytes${n}\
      : Número mínimo de bytes (${S}opcional${n}).\n" >&2
    esac
    exit 1
}
# Expresión regular para comprobar que los bytes son un número.
re='^[0-9]+$'
# Comprobamos que los argumentos son correctos.
if [ $# -lt 1 ] || [ $# -gt 2 ] || [ ! -d $1 ]
then
    error_ayuda 0
elif [ $# -eq 2 ]
then
    if ! [[ $2 =~ $re ]]
    then
        error_ayuda 1
    else
        bytes=$2
    fi
else
    bytes=0
fi

# Recorremos todos los archivos de la carpeta comprobando que el número de bytes
# sea mayor que el deseado.
for x in $(find ${1} -size +${bytes}c)
do
    # Comprobamos si el archivo es o no ejecutable.
    if [ -x $x ]
    then
        ejecutable=1
    else
        ejecutable=0
    fi
    # Solo procesamos archivos, no carpetas.
    if [ ! -d $x ]
    then
        aux=${aux}"`dirname $x`;`basename $x`;`stat -c%s $x`;`stat -c%h $x`;`stat -c%A\
 $x`;$ejecutable\n"
    fi
done

echo "Carpeta;Nombre;Tamaño;ReferenciasInodo;Permisos;Ejecutable"
echo -e $aux | sort -rnk 3 -t ';'
