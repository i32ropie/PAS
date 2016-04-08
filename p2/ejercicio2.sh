#!/bin/bash

# Nombre : ejercicio2.sh
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
./ejercicio2.sh directorio <umbral1> <umbral2>${n}\n\n${N}directorio${n} : Direct\
orio sobre el que trabajar (${S}obligatorio${n}).\n${N}umbral1${n}    : Umbral 1 \
(${S}opcional${n}).\n${N}umbral2${n}    : Umbral 2 (${S}opcional${n}).\n" >&2
            ;;
        1)
            echo -e "${R}${N}[Error]${n} - umbral1 debe ser un número entero.\n\n\
La sintaxis del programa es:\n\n\t${N}./ejercicio2.sh directorio <umbral1> <umbra\
l2>${n}\n\n${N}directorio${n} : Directorio sobre el que trabajar (${S}obligatorio\
${n}).\n${N}umbral1${n}    : Umbral 1 (${S}opcional${n}).\n${N}umbral2${n}    : U\
mbral 2 (${S}opcional${n}).\n" >&2
            ;;
        2)
            echo -e "${R}${N}[Error]${n} - umbral1 y umbral2 deben ser un número \
entero.\n\nLa sintaxis del programa es:\n\n\t${N}./ejercicio2.sh directorio <umbr\
al1> <umbral2>${n}\n\n${N}directorio${n} : Directorio sobre el que trabajar (${S}\
obligatorio${n}).\n${N}umbral1${n}    : Umbral 1 (${S}opcional${n}).\n${N}umbral2\
${n}    : Umbral 2 (${S}opcional${n}).\n" >&2
    esac
    exit 1
}
# Expresión regular para comprobar que los bytes son un número.
re='^[0-9]+$'
# Comprobamos que los argumentos son correctos.
if [ $# -lt 1 ] || [ $# -gt 3 ] || [ ! -d $1 ]
then
    error_ayuda 0
fi
carpeta=$1
case $# in
    1)
        umbral1=10000
        umbral2=100000
        ;;
    2)
        if ! [[ $2 =~ $re ]]
        then
            error_ayuda 1
        else
            umbral1=$2
        fi
        umbral2=100000
        ;;
    3)
    if ! [[ $2 =~ $re ]] || ! [[ $3 =~ $re ]]
        then
            error_ayuda 2
        else
            umbral1=$2
            umbral2=$3
        fi
        ;;
esac
# Comprobamos que umbral1 sea menor que umbral2
if [ $umbral1 -gt $umbral2 ]
then
    aux=$umbral1
    umbral1=$umbral2
    umbral2=$aux
fi
# Si ya existen las carpetas, las borramos y las creamos de nuevo
if [ -e "pequenos" ] || [ -e "medianos" ] || [ -e "grandes" ]
then
    echo "Las carpetas de salida ya existen, se va a proceder a borrarlas..."
    rm -rf pequenos medianos grandes
    mkdir pequenos medianos grandes
else
    echo "Creando las carpetas pequenos, medianos y grandes..."
    mkdir pequenos medianos grandes
fi

echo "Copiando los archivos..."
# Copiamos los archivos pequeños
for x in $(find $carpeta -size -${umbral1}c)
do
    if [ ! -d $x ]
    then
        cp $x pequenos
    fi
done
# Copiamos los archivos medianos
for x in $(find $carpeta -size +${umbral1}c -size -${umbral2}c)
do
    if [ ! -d $x ]
    then
        cp $x medianos
    fi
done
# Copiamos los archivos grandes.
for x in $(find $carpeta -size +${umbral2}c)
do
    if [ ! -d $x ]
    then
        cp $x grandes
    fi
done
