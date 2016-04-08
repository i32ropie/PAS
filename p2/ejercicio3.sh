#!/bin/bash

# Nombre : ejercicio3.sh
# Autor  : Eduardo Roldán Pijuán.

# Variables de formateo de texto.
n='\e[m'    # Nada (Limpia efectos)
N='\e[1m'   # Negrita
S='\e[4m'   # Subrayado
R='\e[31m'  # Rojo

# Función que se ejecuta cuando hay un error en los parámetros y muestra la ayuda.
function error_ayuda() {
    echo -e "${R}${N}[Error]${n} - La sintaxis del programa es:\n\n\t${N}./ejerci\
cio3.sh directorio1 directorio2${n}\n\n${N}directorio1${n} : Directorio del que v\
amos a copiar (${S}obligatorio${n}).\n${N}directorio2${n} : Directorio al que vam\
os a copiar (${S}obligatorio${n}).\n" >&2
    exit 1
}
# Comprobamos que los argumentos son correctos.
if [ $# -ne 2 ] || [ ! -d $1 ]
then
    error_ayuda
fi
# Si ya existe el destino preguntamos si sobreescribir (Por si hay algo importante)
if [ -e $2 ]
then
    echo -en "${N}${S}$2${n} ya existe. ¿Desea sobreescribir el contenido? (s/n): "
    read -n1 respuesta
    if [ $respuesta != "s" ]
    then
        echo -e "\n\nSaliendo del programa...\n"
        exit
    else
        echo
    fi
fi

echo -e "\nProcesando archivos...\n"
# Borramos todo lo que haya en el destino si es que hay y lo creamos de nuevo.
rm -rf $2
mkdir $2
# Recorremos el directorio1
for x in $(find $1)
do
    if [ $x != $1 ] # Con este if nos quitamos el directorio1 de en medio
    then
        if [ -d $x ] # Si es una carpeta, la creamos.
        then
            mkdir $2/$(echo $x | cut -d '/' --complement -s -f1 | tr 'a-z' 'A-Z')
        else # Si no, simplemente copiamos el archivo.
            cp $x $2/$(echo $x | cut -d '/' --complement -s -f1 | tr 'a-z' 'A-Z')
        fi
    fi
done

# EXTRA: Explicación de $(echo $x | cut -d '/' --complement -s -f1 | tr 'a-z' 'A-Z')
# Hago echo de $x para pasarselo a cut, que separa por el carácter '/' y coge
# todo menos la fila 1 (Para quitar $1 de $x). El resultado se lo paso a tr para
# pasarlo a mayúsculas.
