#!/bin/bash

function separador() {
    echo -e "*****************************\n$1) $2:"
}

separador 1 "Títulos de las series"
cat $1 | egrep '^[0-9]+\.'

separador 2 "Cadenas que producen las series"
cat $1 | egrep '^\*'

separador 3 "Cadenas que producen las series sin asteriscos ni espacios"
cat $1 | sed -nre 's/^\* ([A-Z]+) \*/\1/p'

separador 4 "Eliminar las líneas de sinopsis"
# cat $1 | sed -e '/^SINOPSIS/d'
cat $1 | egrep -v '^SINOPSIS'

separador 5 "Eliminar líneas vacías"
# cat $1 | sed -e '/^$/d'
cat $1 | egrep -v '^$'

separador 6 "Contar cuántas series produce cada cadena"
cat $1 | sed -rne 's/\* ([A-Z]+) \*/\1/p' | sort | uniq -c | sed -rne 's/.+([0-9]) ([A-Z]+)/La cadena \2 produce \2 series:/p'

separador 7 "Lı́neas que lı́neas que contengan una palabra en mayúsculas entre paréntesis"
cat $1 | egrep '\(.*[A-Z][a-z]+.*\)'

separador 8 "Emparejamientos de palabras repetidas en la misma lı́nea"
cat $1 | egrep -o '( [^ ]+ ).*\1'

separador 9 "Líneas que contienen 28 aes o más"
cat $1 | egrep '(.*[Aa].*){28}'

serparador 10 "Nombre de película y temporadas"
cat $1 | egrep '^=' -C 1
