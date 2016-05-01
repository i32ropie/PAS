#!/bin/bash

echo "===="
echo "Listado de archivos ocultos del directorio /home/$USER"
ls -a ~ | egrep '^\.' | awk '{print length($0)"\t"$0}' | sort -n | cut --complement -f1

echo "===="
echo "El fichero a procesar es $1"
cat $1 | egrep -v '^$' > $1.sinLineasVacias
echo "El fichero sin lı́neas vacı́as se ha guardado en $1.sinLineasVacias"

echo "===="
echo "Listado de los procesos ejecutados por el usuario $USER:"
ps aux | egrep ^$USER | sed -nre 's/^[^ ]+ +([^ ]+) +[^ ]+ +[^ ]+ +[^ ]+ +[^ ]+ +[^ ]+ +[^ ]+ +([^ ]+) +[^ ]+ +(.*)$/PID: \"\1\" Hora: \"\2\" Ejecutable: \"\3\"/p'
