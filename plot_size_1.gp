reset
set ylabel 'time(sec)'
set xlabel 'size(bytes)'
set style fill solid
set key left
set title 'allocation (1000 objects) elapsed total time comparison'
set term png enhanced font 'Verdana,10'
set output 'runtime_1.png'
set grid

plot 'output_ptmalloc' using 2:xtic(1) w linespoints lw 2 title 'ptmalloc with 2 threads',\
'output_supermalloc' using 2:xtic(1) w linespoints lw 2 title 'supermalloc with 2 threads',\
