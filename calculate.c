#include <stdio.h>
#include <stdlib.h>

void calc_time(FILE *fp, double *avg)
{
    int threads = 0;
    int times = 0;
    int tmp;

    while((fscanf(fp, "%d %lf\n", &tmp, (avg+threads*100+times))) != EOF) {
	    times++;
	    if (times == 100) {
	        times = 0;
	        threads++;
	    }
    }

}

int main()
{
    double avg_ptm[7][100] = {0}; // For thread 1,2,4,8,16,32,64
    double avg_sm[7][100] = {0}; // For thread 1,2,4,8,16,32,64
    FILE *fp = fopen("bench_output","r");
    calc_time(fp, avg_ptm);
    fclose(fp);
    
    fp = fopen("bench_output_SuperMalloc", "r");
    calc_time(fp, avg_sm);
    fclose(fp);

    fp = fopen("output","w+");

    int threads = 1;
    double count_ptm = 0.0, count_sm = 0.0;
    for (int i = 0; i < 7; i++) {
	      for (int j = 0; j < 100; j++) {
	          count_ptm += avg_ptm[i][j];
	          count_sm += avg_sm[i][j];
	      }
	      fprintf(fp, "%d %.10lf %.10lf\n", threads, count_ptm / 100, count_sm / 100);
	      printf("%d %.10lf %.10lf\n", threads, count_ptm / 100, count_sm / 100);
	      count_ptm = 0.0;
	      count_sm = 0.0;
	      threads = threads * 2;
    }
    fclose(fp);
}
