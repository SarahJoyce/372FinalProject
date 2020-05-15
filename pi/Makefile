CC = nvcc
RUN = srun -n 1 --gres=gpu:1

HOST := $(shell hostname)
ifeq ($(HOST),cisc372)
RUN = srun
endif

all : cuda_pi run1 run2 run3

cuda_pi : cudapi.cu
	$(CC) -o cuda_pi cudapi.cu

# Add more rules here for running the cuda version ...

run1 : cuda_pi
	$(RUN) cuda_pi 10 10

run2 : cuda_pi
	$(RUN) cuda_pi 100 100

run3 : cuda_pi
	$(RUN) cuda_pi 1000 1000

clean :
	rm -f cuda_pi *~ a.out
