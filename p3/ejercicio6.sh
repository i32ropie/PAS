#!/bin/bash

# Nombre : ejercicio6.sh
# Autor  : Eduardo Roldán Pijuán

# Variables de formateo de texto.
n='\e[m'    # Nada (Limpia efectos)
N='\e[1m'   # Negrita
S='\e[4m'   # Subrayado
R='\e[31m'  # Rojo

# Función que se ejecuta cuando hay un error en los parámetros y muestra la ayuda.
function error_ayuda() {
    echo -e "${R}${N}[Error]${n} - La sintaxis del programa es:\n\n\t${N}./ejerci\
cicio6.sh directorio${n}\n\n${N}directorio${n} : Directorio sobre el que ejecutar\
 el script (${S}obligatorio${n})." >&2
    exit 1
}

if [ $# -ne 1 ] || [ ! -d $1 ]
then
    error_ayuda
fi

enlaces_simbolicos=0
directorios=0
ejecutables=0
binsh=0
binbash=0
for x in $(find $1/etc)
do
    if [ -d $x ]
    then
        directorios=$[$directorios+1]
    elif [ -L $x ]
    then
        enlaces_simbolicos=$[$enlaces_simbolicos+1]
    elif [ -x $x ]
    then
        ejecutables=$[$ejecutables+1]
        if head -n1 $x | grep '^#! */bin/bash.*$' > /dev/null
        then
            binbash=$[$binbash+1]
        elif head -n1 $x | grep '^#! */bin/sh.*$' > /dev/null
        then
            binsh=$[$binsh+1]
        fi
    fi
done

echo -e "${N}${R}*****************************${n}"
echo -e "Número de enlaces simbólicos: ${N}$enlaces_simbolicos${n}"
echo -e "Número de directorios: ${N}$directorios${n}"
echo -e "Número de ficheros convencionales ejecutables: ${N}$ejecutables${n}"
echo -e "${N}${R}*****************************${n}"
echo -e "El listado de los intérpretes en ${N}$1/etc/init.d/${n} es:"
echo -e "- Hay ${N}$binbash${n} scripts con intérprete ${N}/bin/bash${n}"
echo -e "- Hay ${N}$binsh${n} scripts con intérprete ${N}/bin/sh${n}"
echo -e "${N}${R}*****************************${n}"

declare -A orden=( ["S"]="Arranque" ["K"]="Parada" )

for x in $(find $1/etc/init.d)
do
    if [ ! -d $x ]
    then
        script_padre_nombre=$(basename $x)
        echo -e "${N}----------${n}"
        echo -e "Script ${N}$script_padre_nombre${n}"
        for y in $(find $1/etc/rc?.d)
        do
            if [ ! -d $y ]
            then
                script_hijo=$(basename $y)
                script_hijo_nombre=${script_hijo:3}
                if [ $script_padre_nombre == $script_hijo_nombre ]
                then
                    script_hijo_orden=${script_hijo:0:1}
                    script_hijo_prioridad=${script_hijo:1:2}
                    nivel=$(echo $y | sed -re 's/.*rc(.)\.d.*$/\1/')
                    echo -e "${S}Nivel $nivel${n}: ${N}${orden[$script_hijo_orden]}${n} con prioridad ${N}$script_hijo_prioridad${n}"
                fi
            fi
        done
    fi
done
