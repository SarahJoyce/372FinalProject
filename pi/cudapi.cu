#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>
#define INTERVALS 5000000000L

int nthreads;
int nblocks;
double num_pi;

__global__ void pi(double *area, int threads, int blocks){
  //do individual thread stuff
  double xi;
  int i;
  int threadindex = threadIdx.x + blockIdx.x*threads;
  for (i=threadindex; i<INTERVALS; i+=threads*blocks) {
    xi=(1.0/INTERVALS)*(i+0.5);
    area[i] += 4.0/(INTERVALS*(1.0+xi*xi));
  }
}

int main(int argc, char **argv) {
  clock_t start_time = clock();

  nthreads = (int)atoi(argv[1]);
  nblocks = (int)atoi(argv[2]);

  double *area;
  double *d_area;
  area = (double *)malloc(sizeof(double));

  cudaMalloc((void **) &d_area, nblocks*nthreads*sizeof(double));

  cudaMemcpy(d_area, &area, nblocks*nthreads*sizeof(double), cudaMemcpyHostToDevice);
  //fix the line below
  pi<<<nblocks, nthreads>>>(d_area, nthreads, nblocks);

  cudaMemcpy(&area, d_area, nblocks*nthreads*sizeof(double), cudaMemcpyDeviceToHost);

  //add everything together
  for(int i=0; i<nblocks*nthreads; i++){
    num_pi+=area[i];
  }

  clock_t finish_time = clock();
  double time = (double)(finish_time-start_time)/CLOCKS_PER_SEC;
  
  printf("Pi is %.2f (nthreads = %d, time = %f sec.)\n", num_pi, nthreads, time);
  
  free(area);
  cudaFree(d_area);
  fflush(stdout);
  return 0;
}
