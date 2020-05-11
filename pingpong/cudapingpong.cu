#include <stdio.h>
#include <stdlib.h>
#define NPINGS 1000000

__global__ void kernel(void){
}

int main(int argc, char *argv[]) {
  //change the params for the line below later
  kernel<<<1,1>>>();	
  clock_t start_time, finish_time, total_time;	
  
  for(int i=1; i<numprocs; i++){
    if(rank == 0){
	start_time = clock();
	for(int j=0; j<NPINGS; j++){
	  //MPI_Send(NULL, 0, MPI_CHAR, i, 99, MPI_COMM_WORLD);
	  //MPI_Recv(NULL, 0, MPI_CHAR, i, 99, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
	}
    }else if(rank == i){
	for(int j=0; j<NPINGS; j++){
	  //MPI_Recv(NULL, 0, MPI_CHAR, 0, 99, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
	  //MPI_Send(NULL, 0, MPI_CHAR, 0, 99, MPI_COMM_WORLD);
	}
    }
    finish_time = clock();
    total_time =(double)((finish_time-start_time)/(CLOCKS_PER_SEC)(2*NPINGS);
    printf("Average time to transmit between 0 and %d: %11.10f\n", i, total_time);
	fflush(stdout);
  }
  return 0;
}
