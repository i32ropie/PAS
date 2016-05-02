#!/bin/bash

# Nombre : ejercicio3.sh
# Autor  : Eduardo Roldán Pijuán

# Variables de formateo de texto.
n='\e[m'    # Nada (Limpia efectos)
N='\e[1m'   # Negrita
S='\e[4m'   # Subrayado
R='\e[31m'  # Rojo

# Función que se ejecuta cuando hay un error en los parámetros y muestra la ayuda.
function error_ayuda() {
    echo -e "${R}${N}[Error]${n} - La sintaxis del programa es:\n\n\t${N}./ejerci\
cicio3.sh fichero${n}\n\n${N}fichero${n} : Fichero sobre el que ejecutar el scrip\
t (${S}obligatorio${n})." >&2
    exit 1
}

if [ $# -ne 1 ] || [ ! -f $1 ]
then
    error_ayuda
fi

echo -e "${N}${R}====${n}"
echo -e "${S}Listado de archivos ocultos del directorio /home/$USER${n}${N}"
ls -a ~ | egrep '^\.' | awk '{print length($0)"\t"$0}' | sort -n | cut -f2

echo -e "${N}${R}====${n}"
echo -e "El fichero a procesar es ${S}$1${n}"
cat $1 | egrep -v '^$' > $1.sinLineasVacias
echo -e "El fichero sin lı́neas vacı́as se ha guardado en ${S}$1.sinLineasVacias${n}"

echo -e "${N}${R}====${n}"
echo -e "${S}Listado de los procesos ejecutados por el usuario $USER:${n}${N}"
ps aux | egrep ^$USER | sed -nre 's/^[^ ]+ +([^ ]+) +[^ ]+ +[^ ]+ +[^ ]+ +[^ ]+ +[^ ]+ +[^ ]+ +([^ ]+) +[^ ]+ +(.*)$/PID: \"\1\" Hora: \"\2\" Ejecutable: \"\3\"/p'
echo -ne "${n}"
