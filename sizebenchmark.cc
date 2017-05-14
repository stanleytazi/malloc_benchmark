#include <cstdio>
#include <iostream>
#include <vector>
#include <cassert>
#include <cstring>
#include <cmath>
#include "rdtscp_timer/timing.hh"
#include "supermalloc.h"
#define FRAG 1
#define N_ALLOCS 1000
int THREAD_NUM;

using namespace std;
int power_size;
double times[64][N_ALLOCS];
double clock_speed_ghz;
size_t SIZE;
void *vptr_array[64][N_ALLOCS];
static double count_sum (int id) 
{
    double sum = 0.0;
    for (int i = 0; i < N_ALLOCS; i++)
	    sum += times[id][i];
    return sum;
}

static void *do_malloc (void *arg) 
{
    vector<char*> ptrs;
    int id = *((int*)arg);
    Timer t(clock_speed_ghz);
    for (int i = 0; i < N_ALLOCS; i++) {
	      char *a = NULL;

	      t.tick();
	      vptr_array[id][i] = malloc(SIZE);
	      memset(vptr_array[id][i], rand(), SIZE); // make sure we actually have pages allocated
	      t.tock();

	      assert(!(reinterpret_cast<unsigned long long>(a) & 0xFFFFF));
			
	      #if defined(__GNUC__)
	          __builtin___clear_cache((void *) vptr_array[id][i], (void *) vptr_array[id][i] + (SIZE));
	      #endif
	      times[id][i] = t.get_time();
	      ptrs.push_back(a);
    }
    for (int i = 0; i < N_ALLOCS; i++) {

      free(vptr_array[id][i]);
      vptr_array[id][i] = NULL;
    }

    pthread_exit(NULL);
}

static void testAllocation_output() 
{
    FILE *fp;
    int id[THREAD_NUM];
    pthread_t threads[THREAD_NUM];
    /* Different thread_num different file */
    char s[10];
    sprintf(s, "output_%d", THREAD_NUM);
    fp = fopen(s,"a+");

    /* Separate size to each thread */
    SIZE = pow(2,power_size);
    for (int i = 0; i < THREAD_NUM; i++){
	      id[i] = i;
	      pthread_create(&threads[i], NULL, do_malloc, (void*)&id[i]); 
    }
    for (int i = 0; i < THREAD_NUM; i++)
	      pthread_join(threads[i], NULL);

    double sum = 0.0;
    for (int i = 0; i < THREAD_NUM; i++)
	      sum += count_sum(i);

    fprintf(fp, "%zubytes %.10lf\n", SIZE, sum);
    fclose(fp);
}
// Time the allocations of various sizes
static void testAllocation() 
{
    FILE *fp;
    int id[THREAD_NUM];
    pthread_t threads[THREAD_NUM];
    /* Separate size to each thread */
    SIZE = pow(2,power_size);
    for (int i = 0; i < THREAD_NUM; i++){
	      id[i] = i;
	      pthread_create(&threads[i], NULL, do_malloc, (void*)&id[i]); 
    }
    for (int i = 0; i < THREAD_NUM; i++)
	      pthread_join(threads[i], NULL);
}

int main(int argc, char **argv) 
{
    clock_speed_ghz = 1.6;
    THREAD_NUM = atoi(argv[1]);
    power_size = atoi(argv[2]);
    testAllocation();
    testAllocation_output();
    return 0;
}
