TARGETS = sizebenchmark
OBJS = sizebenchmark.o
CXX := g++
LD := g++
CFLAGS = -lpthread -lm -rdynamic
LDFLAGS =/home/stanle/course/ncku/sysprog21/project1/malloc_benchmark
SPRM_DIR = ../SuperMalloc/src/
TIMER_DIR = ./rdtscp_timer
EXEC = timer sizebenchmark benchmark

all: $(EXEC)

timer:
	cd $(TIMER_DIR); $(MAKE)

sizebenchmark: sizebenchmark.cc timer
	g++ $(TIMER_DIR)/timing.o sizebenchmark.cc -std=c++0x -lrt -lsupermalloc_pthread -o sizebenchmark -I$(SPRM_DIR) -L$(LDFLAGS) $(CFLAGS)

benchmark:
	g++ $(TIMER_DIR)/timing.o benchmark.cc -std=c++0x -lrt -o benchmark $(CFLAGS)

get_output:
	gcc -g $@.c -o $@

bench: $(EXEC) calculate
	for i in 1 2 4 8 16 32 64; do \
	    for j in `seq 1 1 100`; do \
LD_PRELOAD=../SuperMalloc/release/lib/libsupermalloc_pthread.so ./benchmark $$i; \
	    done \
	done
	mv bench_output bench_output_SuperMalloc
	for i in 1 2 4 8 16 32 64; do \
	    for j in `seq 1 1 100`; do \
		./benchmark $$i; \
	    done \
	done
	./calculate

calculate:
	gcc -g $@.c -o $@

plot: bench
	gnuplot plot.gp

# For different malloc implement,
#   Please Change the ./get_output argv
# @Ptmalloc = 0, @Supermalloc = 1, @Allocator = 2
sizebench: $(EXEC) get_output
	for i in 1 2 4 8 16 32 64; do \
	    for j in 2 4 5 6 8 10 12; do \
	    	for k in `seq 1 1 100`; do \
					./sizebenchmark $$i $$j; \
	    	done \
			done \
	done
	./get_output 0 7 100
	rm -rf output_1 output_2 output_4 output_8 output_16 output_32 output_64
	for i in 1 2 4 8 16 32 64; do \
	    for j in 2 4 5 6 8 10 12; do \
	    		for k in `seq 1 1 100`; do \
LD_PRELOAD=../SuperMalloc/release/lib/libsupermalloc_pthread.so ./sizebenchmark $$i $$j; \
	    		done \
			done \
	done
	./get_output 1 7 100
	 rm -rf output_1 output_2 output_4 output_8 output_16 output_32 output_64

clean:
	rm -rf sizebenchmark calculate get_output benchmark
	rm -rf output bench_output runtime.png output_frag output_nofrag 
	rm -rf output_1 output_2 output_4 output_8 output_16 output_32 output_64
