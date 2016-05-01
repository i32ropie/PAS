#!/bin/bash

origen=$1
destino=${origen%.*}.html
echo "<html>" > $destino
cat $1 | egrep -v '^$' | sed -nre '0,/:$/{s/^(.*):$/<title> \1 <\/title>/p}' >> $destino
echo "<body>" >> $destino
cat $1 | egrep -v '^$' | sed -re '0,/:$/{/^(.*):$/d}' | sed -re 's/^(.*)$/<p>\1<\/p>/' >> $destino
echo "</body>" >> $destino
echo "</html>" >> $destino
