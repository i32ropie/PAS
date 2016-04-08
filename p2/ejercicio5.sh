#!/bin/bash

# Nombre : ejercicio5.sh
# Autor  : Eduardo Roldán Pijuán.

# Variables de formateo de texto.
n='\e[m'    # Nada (Limpia efectos)
N='\e[1m'   # Negrita
S='\e[4m'   # Subrayado
R='\e[31m'  # Rojo

# Función que se ejecuta cuando hay un error en los parámetros y muestra la ayuda.
function error_ayuda() {
    case $1 in
        0)
            echo -e "${R}${N}[Error]${n} - La sintaxis del programa es:\n\n\t${N}\
./ejercicio5.sh clave caracteres${n}\n\n${N}clave${n}      : Clave a desencriptar\
 (${S}obligatorio${n}).\n${N}caracteres${n} : Número de caracteres a desencriptar\
 (${S}obligatorio${n}).\n" >&2
            ;;
        1)
            echo -e "${R}${N}[Error]${n} - La clave debe ser de 40 caracteres.\n\
\nLa sintaxis del programa es:\n\n\t${N}./ejercicio5.sh clave caracteres${n}\n\n\
${N}clave${n}      : Clave a desencriptar(${S}obligatorio${n}).\n${N}caracteres\
${n} : Número de caracteres a desencriptar (${S}obligatorio${n}).\n" >&2
            ;;
        2)
            echo -e "${R}${N}[Error]${n} - Los caracteres deben ser un número ent\
re 1 y 3.\n\nLa sintaxis del programa es:\n\n\t${N}./ejercicio5.sh clave caracter\
es${n}\n\n${N}clave${n}      : Clave a desencriptar(${S}obligatorio${n}).\n${N}ca\
racteres${n} : Número de caracteres a desencriptar (${S}obligatorio${n}).\n" >&2
            ;;
    esac
    # echo "Error"
    exit 1
}

function comparar() {
    if [ $(echo $2 | sha1sum | cut -d ' ' -f1 ) == $1 ]
    then
        echo "Encontrada la clave: $2"
        exit
    fi
}
# Expresión regular para comprobar que el número de caracteres sea un número.
re='^[1-3]$'
# Comprobamos que los argumentos son correctos.
if [ $# -ne 2 ]
then
    error_ayuda 0
elif [ ${#1} -ne 40 ]
then
    error_ayuda 1
elif ! [[ $2 =~ $re ]]
then
    error_ayuda 2
fi

echo "Buscando contraseñas de ${2} caracteres..."

case ${2} in
    1)
        for x in {a..z} # -> a..z
        do
            comparar $1 $x
        done
        ;;
    2)
        for x in {a..z}{a..z} # -> aa..zz
        do
            comparar $1 $x
        done
        ;;
    3)
        for x in {a..z}{a..z}{a..z} # -> aaa.zzz
        do
            comparar $1 $x
        done
        ;;
esac
