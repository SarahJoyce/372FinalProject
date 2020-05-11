/* 
 * Some tests:
 * 1 -> 0
 * 2 -> 7080
 * 100 -> 0076
 *
 * 100000000 takes 4.2 seconds on my MacBook Air
 * 1000000000  takes 43 seconds on same machine
 */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
//int rank;
//int numprocs;
int pin;

__global__ void pin(void){
}

//int main(void)??
int main(int argc, char *argv[]) {
  //change the params below later
  pin<<<1,1>>>();
  clock_t start_time = clock();
  assert(argc==2);

  double stop = (double)atol(argv[1]);
  assert(stop >= 1.0);

  int result = 0;

  //fix rank and numprocs below
  for (double x = (double)rank; x < stop; x += (double)numprocs) {
    double tmp = sin(x);
    double tmp2 = tmp*tmp;
    int z = (int)(tmp2*10000.0);

    result = (result + z)%10000; // 0<=result<10000
  }
  //MPI_Reduce used to be here
  pin = pin%10000;
  clock_t finish_time = clock();
  double time = (double)(finish_time-start_time)/CLOCKS_PER_SEC;
  printf("The PIN is %d (nprocs = %d, time = %f sec.)\n", pin, numprocs, time);
  fflush(stdout);
  return 0;
}
