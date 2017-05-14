reset
set ylabel 'time(sec)'
set xlabel 'Thread(n)'
set style fill solid
set key left
set title '2^2 - 2^{22} bytes allocation elapsed total time'
set term png enhanced font 'Verdana,10'
set output 'runtime.png'
set grid

plot 'output' using 2:xtic(1) w linespoints lw 2 title 'ptmalloc',\
'' using 3:xtic(1) w linespoints lw 2 title 'supermalloc',\
