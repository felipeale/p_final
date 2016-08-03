#!/bin/bash

DATA=/home/farias/Downloads/Proyecto-de-Programacion/problema1/hojasDatos
mkdir $DATA/archivos_csv

OUT_DATA=$DATA/archivos_csv

m=0

for i in `find $DATA -name '*.xls' `	
do 
	echo "Procesando Archivo $i"


	xls2csv $i > $OUT_DATA/data-$m.csv
	let m=m+1
done 2> error1.log 
