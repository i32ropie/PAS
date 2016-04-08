#!/bin/bash -v

# Nombre : ejercicio1.sh
# Autor  : Eduardo Roldán Pijuán.

# Variables de formateo de texto.
n='\e[m'
N='\e[1m'
S='\e[4m'
R='\e[31m'
# Función que se ejecuta cuando hay un error en los parámetros y muestra la ayuda.
function error_ayuda() {
    echo -e "${R}${N}[Error]${n} - La sintaxis del programa es:\n\n\t${N}./ejerci\
cio1.sh directorio <bytes>${n}\n\n${N}directorio${n} : Directorio sobre el que tr\
abajar (${S}obligatorio${n}).\n${N}bytes${n}      : Número mínimo de bytes (${S}o\
pcional${n}).\n" >&2
    exit 1
}
# Expresión regular para comprobar que los bytes son un número.
re='^[0-9]+$'
# Comprobamos que los argumentos son correctos.
if [ $# -lt 1 ] || [ $# -gt 2 ] || [ ! -d $1 ]
then
    error_ayuda
elif [ $# -eq 2 ]
then
    if ! [[ $2 =~ $re ]]
    then
        error_ayuda
    else
        bytes=$2
    fi
else
    bytes=0
fi

echo "Carpeta;Nombre;Tamaño;ReferenciasInodo;Permisos;Ejecutable"
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
        echo "`dirname $x`;`basename $x`;`stat -c%s $x`;`stat -c%h $x`;`stat -c%A\
 $x`;$ejecutable"
    fi
done
