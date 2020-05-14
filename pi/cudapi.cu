#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <cuda_runtime.h>
#define INTERVALS 5000000000
#define nblocks 10
#define nthreads 10

double num_pi = 0.0;

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

  //nblocks = (int)atoi(argv[1]);
  //nthreads = (int)atoi(argv[2]);

  dim3 numBlocks(nblocks);
  dim3 threadsPerBlock(nthreads);

  double *area;
  double *d_area;
  area = (double *)malloc(nblocks*nthreads*sizeof(double));
  for(int i=0; i<nblocks*nthreads; i++){
    area[i]=0;
  }

  cudaMalloc((void **) &d_area, nblocks*nthreads*sizeof(double));

  cudaMemcpy(d_area, area, nblocks*nthreads*sizeof(double), cudaMemcpyHostToDevice);

  pi<<<numBlocks, threadsPerBlock>>>(d_area, nthreads, nblocks);

  cudaMemcpy(&area, d_area, nblocks*nthreads*sizeof(double), cudaMemcpyDeviceToHost);

  //add everything together
  for(int i=0; i<nblocks*nthreads; i++){
    num_pi += area[i];
  }
  num_pi = num_pi * (1.0/INTERVALS);

  clock_t finish_time = clock();
  double time = (double)(finish_time-start_time)/CLOCKS_PER_SEC;
  
  printf("Pi is %.2f (nthreads = %d, time = %f sec.)\n", num_pi, nthreads, time);
  
  free(area);
  cudaFree(d_area);
  fflush(stdout);
  return 0;
}
