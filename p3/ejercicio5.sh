#!/bin/bash

cat /proc/cpuinfo | sort | uniq | sed -nre 's/^model name.*: (.*)/Modelo del procesador: \1/p'
cat /proc/cpuinfo | sort | uniq | sed -nre '0,/^cpu MHz/{s/^cpu MHz.*: (.*)$/Megahercios: \1/p}'
echo "TODO: Número máximo de hilos de ejecución."
echo "TODO: Puntos de montaje activos, incluyendo el dispositivo, el punto de montaje y el tipo de sistema de ficheros. Ordenarlos de forma alfabética por tipo de dispositivo."
echo "Particiones y número de bloques:"
cat /proc/partitions | sed -nre '3,$s/^ +[0-9]+ +[0-9]+ +([0-9]+) +(.*)$/-> Partición: \2, Número de bloques: \1/p'
