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
__global__ void pin(int *d_result, double stop){
  for(double x=(double)blockIdx.x; x<stop;x+=(double)gridDim.x){
    double tmp=sin(x);
    tmp=tmp*tmp;
    int z=(int) (tmp*10000.0);
    d_result[(int)x]=(d_result[(int)x]+z)%10000;
//    printf("x=%d is %f\n",x,d_result[(int)x]);
  }
}

//int main(void)??
int main(int argc, char *argv[]) {
  //change the params below later
  int numBlocks=100;
  clock_t start_time = clock();
  assert(argc==2);

  double stop = (double)atol(argv[1]);
  assert(stop >= 1.0);

  int *result = (int*)malloc(numBlocks*sizeof(int));
  for(int i=0;i<numBlocks;i++){
    result[i]=0;
  }


  int *d_result;
  cudaMalloc((void**)&d_result, numBlocks*sizeof(int));
  cudaMemcpy(d_result, &result, numBlocks*sizeof(int), cudaMemcpyHostToDevice);

  pin<<<numBlocks,1>>>(d_result,stop);

  //MPI_Reduce used to be here
  cudaMemcpy(result, d_result, sizeof(int),cudaMemcpyDeviceToHost);
  
  int pin=0;

  for(int i=0;i<numBlocks;i++){
    pin=(pin+result[i])%10000;	
  }
  clock_t finish_time = clock();
  double time = (double)(finish_time-start_time)/CLOCKS_PER_SEC;
  printf("The PIN is %d (numBlocks = %d, time = %f sec.)\n", pin, numBlocks, time);
  cudaFree(d_result);
  fflush(stdout);
  return 0;
}
