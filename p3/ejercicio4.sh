#!/bin/bash

# Nombre : ejercicio4.sh
# Autor  : Eduardo Roldán Pijuán

# Variables de formateo de texto.
n='\e[m'    # Nada (Limpia efectos)
N='\e[1m'   # Negrita
S='\e[4m'   # Subrayado
R='\e[31m'  # Rojo

# Función que se ejecuta cuando hay un error en los parámetros y muestra la ayuda.
function error_ayuda() {
    echo -e "${R}${N}[Error]${n} - La sintaxis del programa es:\n\n\t${N}./ejerci\
cicio4.sh fichero${n}\n\n${N}fichero${n} : Fichero sobre el que ejecutar el scrip\
t (${S}obligatorio${n})." >&2
    exit 1
}

if [ $# -ne 1 ] || [ ! -f $1 ]
then
    error_ayuda
fi

origen=$1
destino=${origen%.*}.html
echo "Generando el fichero $destino..."
echo "<html>" > $destino
cat $1 | egrep -v '^$' | sed -nre '0,/:$/{s/^(.*):$/<title> \1 <\/title>/p}' >> $destino
echo "<body>" >> $destino
cat $1 | egrep -v '^$' | sed -re '0,/:$/{/^(.*):$/d}' | sed -re 's/^(.*)$/<p>\1<\/p>/' >> $destino
echo "</body>" >> $destino
echo "</html>" >> $destino
