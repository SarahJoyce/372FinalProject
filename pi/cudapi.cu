#include <stdio.h>
#include <stdlib.h>
#define INTERVALS 5000000000L

//int rank;
//int numprocs;
long double pi;

__global__ void pi(void){
//do individual thread stuff
}

//int main(void)??
int main(int argc, char *argv[]) {    
  long double area = 0.0;
  long double xi;
  long i;

  clock_t start_time = clock();

  //fix rank and numprocs below
  for (i=(long)rank; i<INTERVALS; i+=(long)numprocs) {
    xi=(1.0L/INTERVALS)*(i+0.5L);
    area += 4.0L/(INTERVALS*(1.0L+xi*xi));
  }
  //MPI_Reduce used to be here (add everything together)
  clock_t finish_time = clock();
  double time = (double)(finish_time-start_time)/CLOCKS_PER_SEC;
  //back to main here (used to be rank == 0)
  printf("Pi is %20.17Lf (nprocs = %d, time = %f sec.)\n", pi, numprocs, time);
  fflush(stdout);
  return 0;
}
