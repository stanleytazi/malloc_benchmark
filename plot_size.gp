reset
set ylabel 'time(sec)'
set xlabel 'size(bytes)'
set style fill solid
set key left
set title 'allocation (100 objects) elapsed total time comparison'
set term png enhanced font 'Verdana,10'
set output 'runtime.png'
set grid

plot 'output_ptmalloc' using 2:xtic(1) w linespoints lw 2 title 'ptmalloc with 2 threads',\
'output_supermalloc' using 2:xtic(1) w linespoints lw 2 title 'supermalloc with 2 threads',\
'output_ptmalloc' using 3:xtic(1) w linespoints lw 2 title 'ptmalloc with 4 threads',\
'output_supermalloc' using 3:xtic(1) w linespoints lw 2 title 'supermalloc with 4 threads',\
'output_ptmalloc' using 4:xtic(1) w linespoints lw 2 title 'ptmalloc with 8 threads',\
'output_supermalloc' using 4:xtic(1) w linespoints lw 2 title 'supermalloc with 8 threads',\
'output_ptmalloc' using 5:xtic(1) w linespoints lw 2 title 'ptmalloc with 16 threads',\
'output_supermalloc' using 5:xtic(1) w linespoints lw 2 title 'supermalloc with 16 threads',\
'output_ptmalloc' using 6:xtic(1) w linespoints lw 2 title 'ptmalloc with 32 threads',\
'output_supermalloc' using 6:xtic(1) w linespoints lw 2 title 'supermalloc with 32 threads',\
