# Gnuplot script file for plotting data in file "data.dat"
set   autoscale                        # scale axes automatically
unset log                              # remove any log-scaling
unset label                            # remove any previous labels
set title "Producer and Consumer"
set xlabel "Time to process data"
set ylabel "number of items"
set style data linespoints
set term png
set output filename
set key bottom right


plot 'data11.dat' using 1:2 t "1p, 1c", \
'data12.dat' using 1:2 t "1p, 2c",\
'data21.dat' using 1:2 t "2p, 1c",\
'data22.dat' using 1:2 t "2p, 2c",\