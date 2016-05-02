#!/bin/bash

# Nombre : ejercicio1.sh
# Autor  : Eduardo Roldán Pijuán

# Variables de formateo de texto.
n='\e[m'    # Nada (Limpia efectos)
N='\e[1m'   # Negrita
S='\e[4m'   # Subrayado
R='\e[31m'  # Rojo

# Función que se ejecuta cuando hay un error en los parámetros y muestra la ayuda.
function error_ayuda() {
    echo -e "${R}${N}[Error]${n} - La sintaxis del programa es:\n\n\t${N}./ejerci\
cicio1.sh fichero${n}\n\n${N}fichero${n} : Fichero sobre el que ejecutar el scrip\
t (${S}obligatorio${n})." >&2
    exit 1
}

function separador() {
    echo -e "${n}${N}${R}*****************************${n}\n$1) ${S}$2${n}:${N}"
}

if [ $# -ne 1 ] || [ ! -f $1 ]
then
    error_ayuda
fi

separador 1 "Títulos de las series"
cat $1 | egrep '^[0-9]+\.'

separador 2 "Cadenas que producen las series"
cat $1 | egrep '^\*'

separador 3 "Cadenas que producen las series sin asteriscos ni espacios"
cat $1 | egrep '^\* [A-Z]+ \*$' | egrep -o '[A-Z]+'

separador 4 "Eliminar las líneas de sinopsis"
cat $1 | egrep -v '^SINOPSIS'

separador 5 "Eliminar líneas vacías"
cat $1 | egrep -v '^$'

separador 6 "Contar cuántas series produce cada cadena"
OLDIFS=$IFS
IFS=$'\n'
for x in $(cat $1 | egrep '^\* [A-Z]+ \*$' | egrep -o '[A-Z]+' | sort | uniq -c)
do
    echo "La cadena $(echo $x | egrep -o '[A-Z]+') produce $(echo $x | egrep -o '[0-9]+') series:"
done
IFS=$OLDIFS

separador 7 "Lı́neas que lı́neas que contengan una palabra en mayúsculas entre paréntesis"
cat $1 | egrep '\(.*[A-Z][a-z]+.*\)'

separador 8 "Emparejamientos de palabras repetidas en la misma lı́nea"
cat $1 | egrep -o '( [^ ]+ ).*\1'

separador 9 "Líneas que contienen 28 aes o más"
cat $1 | egrep '(.*[Aa].*){28}'

separador 10 "Nombre de película y temporadas"
cat $1 | egrep '^=' -C 1
