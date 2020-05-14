#include <stdio.h>
#include <stdlib.h>

__global__ void pingpong(void){}

int main(int argc, char *argv[]){
	int runs=atoi(argv[1]);

	clock_t start_time=clock();
	for(int i=0;i<runs;i++){
	}
	clock_t finish_time=clock();
	
	clock_t cuda_start=clock();
	for(int i=0;i<runs;i++){
		pingpong<<<1,1>>>();
	}
	clock_t cuda_finish=clock();

	double time = (double)(finish_time-start_time)/CLOCKS_PER_SEC;
	time=time/runs;
	double cuda_time=(double)(cuda_finish-cuda_start)/CLOCKS_PER_SEC;
	cuda_time=cuda_time/runs;
	printf("Each loop took an average of %11.10f sec without cuda.\n",time);
	printf("Each loop took an average of %11.10f sec with cuda.\n",cuda_time);
}
