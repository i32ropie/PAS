#!/bin/bash

# Nombre : ejercicio5.sh
# Autor  : Eduardo Roldán Pijuán

cat /proc/cpuinfo | sort | uniq | sed -nre 's/^model name.*: (.*)/Modelo del procesador: \1/p'
cat /proc/cpuinfo | sort | uniq | sed -nre '0,/^cpu MHz/{s/^cpu MHz.*: (.*)$/Megahercios: \1/p}'
cat /proc/cpuinfo | sort | uniq | cut -f1 | uniq -c | sed -nre 's/^ *([0-9]+) processor$/Número de hilos máximo de ejecución: \1/p'
echo "Puntos de montaje:"
cat /proc/mounts | sed -nre 's/^([^ ]+) ([^ ]+) ([^ ]+) .*$/-> Punto de montaje: \2, Dispositivo: \1, Tipo de dispositivo: \3/p'
echo "Particiones y número de bloques:"
cat /proc/partitions | sed -nre '3,$s/^ +[0-9]+ +[0-9]+ +([0-9]+) +(.*)$/-> Partición: \2, Número de bloques: \1/p'
