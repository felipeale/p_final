#!/bin/bash

DATA=/home/farias/git/p_final/Proyecto-de-Programacion/problema2
OUT_DATA=$DATA/archivos_csv
GRAF_DATA=$DATA/datos_graf
FULL_DATA=$DATA/full_datos

mkdir $DATA/archivos_csv
mkdir $GRAF_DATA
mkdir $FULL_DATA

m=0

for i in `find $DATA -name '*.xls' `	
do 
	echo "Procesando Archivo $i"
	xls2csv $i > $OUT_DATA/data-$m.csv
	let m=m+1
done 2> error1.log

m=0

# En esta instruccion iniciamos la preparacion de la informacion requerida
# y solo extraemos la necesaria en este caso Luz y Agua

for e in `find $OUT_DATA -name "*.csv"`
do
	echo "Dando formato de datos para graficar el archivo $e"
	cat $e | awk -F "\",\"" '{print $1 " " $2}' | sed '1,$ s/"//g' | grep -E 'Agua|Luz' > $GRAF_DATA/graf-$m.dat
		let m=m+1
done 2> error2.log

# Este condicional elimina los archivos full.dat ya que si corre varias veces
# entonces se agregaran mas datos al archivo en lugar de crearlo con los 
# datos generados. Osea se agregan por cada corrida un duplicado de los mismos
# datos.

if [ -a $FULL_DATA/full-1.dat ]
then
	rm $FULL_DATA/*.dat
	echo "Archivos anteriores borrados"
fi 2> errorIf.log

# Esta instruccion es para crear consolidados de los archivos para cada servicio
# por separado 

for k in `find $GRAF_DATA -name "*.dat"`
do
	sed '1d' $k >> $FULL_DATA/full-1.dat
	echo "Procesando Archivo $k"
        sed '2d' $k >> $FULL_DATA/full-2.dat
        echo "Procesando Archivo $k"


done 2> error3.log

#Grafico del Primer servicio

FMT_BEGIN='Luz'
FMT_END='Luz'
FMT_X_SHOW=%H:%M
DATA_DONE=$FULL_DATA/full-1.dat

graficar()

{
	gnuplot << EOF 2>errorGraf2.log
#	set xdata time
#	set timefmt "%Y%m%d%H%M"
#	set range ["$FMT_BEGIN" : "$FMT_END"]
#	set format x "$FMT_X_SHOW"
	set xlabel "Servicio"
	set ylabel "Monto"
	set terminal png
	set output 'fig1.png'
#	plot "$DATA_DONE" using 1:1 with lines title "sensor1","$DATA_DONE" using 1:2 with linespoints title "sensor2"
EOF

}

#Grafico del Segundo Servicio

FMT_BEGIN='Agua'
FMT_END='Agua'
FMT_X_SHOW=%H:%M
DATA_DONE=$FULL_DATA/full-2.dat

graficar()

{
        gnuplot << EOF 2>errorGraf1.log
#       set xdata time
#       set timefmt "%Y%m%d%H%M"
#       set range ["$FMT_BEGIN" : "$FMT_END"]
#       set format x "$FMT_X_SHOW"
        set xlabel "Servicio"
        set ylabel "Monto"
        set terminal png
        set output 'fig2.png'
#       plot "$DATA_DONE" using 1:1 with lines title "sensor1","$DATA_DONE" using 1:2 with linespoints title "sensor2"
EOF

}


graficar
