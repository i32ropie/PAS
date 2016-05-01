#!/bin/bash

cat series.txt |
    egrep -v '^$|^=' |
    sed -re 's/Ver mas//' |
    sed -re 's/^([0-9]+\. [a-Z \.]+) \((.*)\)$/\1\n|-> Año de la serie: \2/' |
    sed -re 's/^([0-9]+) TEMPORADAS$/|-> Número de temporadas: \1/' |
    sed -re 's/^\* ([A-Z]+) \*$/|-> Productora de la serie: \1/' |
    sed -re 's/^SINOPSIS: (.*)$/|-> Sinopsis: \1/' |
    sed -re 's/^Ha recibido ([0-9]+) puntos$/|-> Número de puntos: \1/'
