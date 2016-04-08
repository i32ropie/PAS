#!/bin/bash

# Nombre : ejercicio4.sh
# Autor  : Eduardo Roldán Pijuán.

# Variables de formateo de texto.
n='\e[m'    # Nada (Limpia efectos)
N='\e[1m'   # Negrita
S='\e[4m'   # Subrayado
R='\e[31m'  # Rojo

# Función que se ejecuta cuando hay un error en los parámetros y muestra la ayuda.
function error_ayuda() {
    echo -e "${R}${N}[Error]${n} - La sintaxis del programa es:\n\n\t${N}./ejerci\
cio3.sh fichero${n}\n\n${N}fichero${n} : Fichero/Directorio a encriptar (${S}obli\
gatorio${n})\n" >&2
    exit 1
}
# Comprobamos que los argumentos son correctos.
if [ $# -ne 1 ] || [ ! -e $1 ]
then
    error_ayuda
fi

if [ ! -d $1 ]
then
    echo "Procesando un fichero"
    gpg --output $(basename $1).gpg --symmetric $1
    echo "Fichero cifrado resultante: $(basename $1).gpg"
else
    echo "Procesando un directorio"
    tar zcf $(basename $1).tar.gz $1
    gpg --output $(basename $1).tar.gz.gpg --symmetric $(basename $1).tar.gz
    rm $(basename $1).tar.gz
    echo "Fichero cifrado resultante: $(basename $1).tar.gz"
fi
