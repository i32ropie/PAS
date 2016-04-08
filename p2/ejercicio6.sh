#!/bin/bash

# Nombre : ejercicio6.sh
# Autor  : Eduardo Roldán Pijuán.

# Variables a usar durante la ejecución del script
tiempoPrincipio=$(date +%s)
fichero_log="ejercicio6.log"
rm -f $fichero_log
bins=0
libs=0
imgs=0
hdrs=0

# Función que guarda en el log los argumentos pasados añadiéndole la fecha.
function log() {
    echo "$(date +%F\ \[%X\]) - $*" >> $fichero_log
}

# Función para comprobar si un directorio existe y crearlo si no existe.
function comprobar() {
    if [ -e $1 ]
    then
        echo "El directorio $1 ya existía"
        log "El directorio $1 ya existía por lo que no se ha creado"
    else
        mkdir $1
        log "Directorio $1 creado con éxito"
    fi
}

# Función para copiar $1 en $2. Pregunta si sobreescribir $2 cuando exista.
function copiar() {
    if [ ! -e $2 ]
    then
        cp $1 $2
        log "Fichero $1 copiado a $2"
    else
        read -n1 -p "El fichero $2 existe. ¿Desea sobreescribirlo? (s/n): " r
        echo
        if [ $r == "s" ]
        then
            cp $1 $2
            log "Fichero $1 sobreescrito a $2"
        else
            log "Fichero $1 NO sobreescrito a $2"
        fi
    fi
}

# Función que convierte $1 en un pdf, lo copia y borra el temporal.
function convertir_y_copiar() {
    archivo=$(basename $1)
    origen=$(dirname $1)
    archivo=${archivo%.*}
    convert $1 /tmp/$archivo.pdf
    log "Fichero $1 convertido a $archivo.pdf"
    copiar /tmp/$archivo.pdf $imagenesDir/$archivo.pdf
    rm -f /tmp/$archivo.pdf
}

# Comprobamos si hemos pasado algún directorio como argumento
if [ $# -eq 0 ]
then
    directorios=.
    nDirectorios=1
else
    directorios=$@
    nDirectorios=$#
fi

# Preguntamos las carpetas destino
read -t5 -p "Introduzca el directorio donde copiar los ejecutables: " aux
ejecutablesDir=${aux:-~/bin}
echo
read -t5 -p "Introduzca el directorio donde copiar las librerias: " aux
libreriasDir=${aux:-~/lib}
echo
read -t5 -p "Introduzca el directorio donde copiar las imágenes: " aux
imagenesDir=${aux:-~/img}
echo
read -t5 -p "Introduzca el directorio donde copiar las cabeceras: " aux
cabecerasDir=${aux:-~/include}
echo

echo "Utilizando los ficheros:"
echo "$ejecutablesDir para almacenar los ficheros ejecutables"
echo "$libreriasDir para almacenar las librerías"
echo "$imagenesDir para almacenar las imágenes"
echo "$cabecerasDir para almacenar los ficheros de las cabeceras"

# Comprobamos que las carpetas destino no existen
for x in $ejecutablesDir $libreriasDir $imagenesDir $cabecerasDir
do
    comprobar $x
done

if [ $nDirectorios -gt 1 ]
then
    echo "Procesando el directorio $directorios ..."
else
    echo "Procesando los directorios $directorios ..."
fi

# Recorremos los directorios
for x in $(find $directorios)
do
    # Caso: Ejecutables
    if [ ! -d $x ] && [ -x $x ]
    then
        copiar $x $ejecutablesDir/$(basename $x)
        bins=$[$bins+1]
    # Caso: Librerías
    elif [[ $(basename $x) =~ ^lib ]]
    then
        copiar $x $libreriasDir/$(basename $x)
        libs=$[$libs+1]
    # Caso: Imágenes
    elif [[ $(basename $x) =~ \.jpg|\.png|\.gif$ ]]
    then
        convertir_y_copiar $x
        imgs=$[$imgs+1]
    # Caso: Cabeceras
    elif [[ $(basename $x) =~ \.h$ ]]
    then
        copiar $x $cabecerasDir/$(basename $x)
        hdrs=$[$hdrs+1]
    fi
done
echo "Número de directorios procesados: $nDirectorios"
echo "Número de ficheros ejecutables: $bins"
echo "Número de librerías: $libs"
echo "Número de imágenes: $imgs"
echo "Número de ficheros de cabecera: $hdrs"
tiempoFinal=$(date +%s)
echo "Tiempo necesario: $[$tiempoFinal-$tiempoPrincipio]"
