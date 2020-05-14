#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <cuda_runtime.h>
#define INTERVALS 5000000000

int nthreads;
int nblocks;
double num_pi;

__global__ void pi(double *d_area){
  //do individual thread stuff
  double xi;
  long i;
  int a = 0;
  int threadindex = threadIdx.x + blockIdx.x*blockDim.x;
  int threads = gridDim.x * blockDim.x;
  for (i=threadindex; i<INTERVALS; i+=threads) {
    xi=(1.0/INTERVALS)*(i+0.5);
    a = 4.0/(INTERVALS*(1.0+xi*xi));
  }d_area[threadindex] = a;
}

int main(int argc, char **argv) {
  clock_t start_time = clock();

  nblocks = (int)atoi(argv[1]);
  nthreads = (int)atoi(argv[2]);

  double *area;
  double *d_area;
  area = (double *)malloc(nblocks*nthreads*sizeof(double));
  for(int i=0; i<nblocks*nthreads; i++){
    area[i]=0;
  }

  cudaMalloc((double **) &d_area, nblocks*nthreads*sizeof(double));

  cudaMemcpy(d_area, area, nblocks*nthreads*sizeof(double), cudaMemcpyHostToDevice);

  pi<<<nblocks, nthreads>>>(d_area);

  cudaMemcpy(area, d_area, nblocks*nthreads*sizeof(double), cudaMemcpyDeviceToHost);

  //add everything together
  for(int i=0; i<nblocks*nthreads; i++){
    num_pi += area[i];
  }

  clock_t finish_time = clock();
  double time = (double)(finish_time-start_time)/CLOCKS_PER_SEC;
  
  printf("Pi is %.2f (nthreads = %d, time = %f sec.)\n", num_pi, nthreads, time);
  
  free(area);
  cudaFree(d_area);
  fflush(stdout);
  return 0;
}
