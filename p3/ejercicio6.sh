#!/bin/bash

echo "TODO: COMPROBACIONES"

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

echo "*****************************"
echo "Número de enlaces simbólicos: $enlaces_simbolicos"
echo "Número de directorios: $directorios"
echo "Número de ficheros convencionales ejecutables: $ejecutables"
echo "*****************************"
echo "El listado de los intérpretes en $1/etc/init.d/ es:"
echo "- Hay $binbash scripts con intérprete /bin/bash"
echo "- Hay $binsh scripts con intérprete /bin/sh"
echo "*****************************"
# echo "enlaces_simbolicos: $enlaces_simbolicos"
# echo "directorios: $directorios"
# echo "ejecutables: $ejecutables"
# echo "/bin/bash: $binbash"
# echo "/bin/sh: $binsh"

declare -A orden=( ["S"]="Arranque" ["K"]="Parada" )

for x in $(find $1/etc/init.d)
do
    if [ ! -d $x ]
    then
        script_padre_nombre=$(basename $x)
        echo "----------"
        echo "Script $script_padre_nombre"
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
                    echo "Nivel $nivel: ${orden[$script_hijo_orden]} con prioridad $script_hijo_prioridad"
                fi
            fi
        done
    fi
done
