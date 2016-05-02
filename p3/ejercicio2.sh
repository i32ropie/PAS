#!/bin/bash

# Nombre : ejercicio2.sh
# Autor  : Eduardo Roldán Pijuán

# Variables de formateo de texto.
n='\e[m'    # Nada (Limpia efectos)
N='\e[1m'   # Negrita
S='\e[4m'   # Subrayado
R='\e[31m'  # Rojo

# Función que se ejecuta cuando hay un error en los parámetros y muestra la ayuda.
function error_ayuda() {
    echo -e "${R}${N}[Error]${n} - La sintaxis del programa es:\n\n\t${N}./ejerci\
cicio2.sh fichero${n}\n\n${N}fichero${n} : Fichero sobre el que ejecutar el scrip\
t (${S}obligatorio${n})." >&2
    exit 1
}

if [ $# -ne 1 ] || [ ! -f $1 ]
then
    error_ayuda
fi

cat series.txt |
    egrep -v '^$|^=' |
    sed -re 's/Ver mas//' |
    sed -re 's/^([0-9]+\. [a-Z \.]+) \((.*)\)$/\1\n|-> Año de la serie: \2/' |
    sed -re 's/^([0-9]+) TEMPORADAS$/|-> Número de temporadas: \1/' |
    sed -re 's/^\* ([A-Z]+) \*$/|-> Productora de la serie: \1/' |
    sed -re 's/^SINOPSIS: (.*)$/|-> Sinopsis: \1/' |
    sed -re 's/^Ha recibido ([0-9]+) puntos$/|-> Número de puntos: \1/'
