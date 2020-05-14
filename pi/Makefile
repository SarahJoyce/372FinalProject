CC = nvcc
RUN = srun -n 10 --gres=gpu:1

HOST := $(shell hostname)
ifeq ($(HOST),cisc372)
RUN = srun
endif

all : cuda_pi run

cuda_pi : cudapi.cu
	$(CC) -o cuda_pi cudapi.cu

# Add more rules here for running the cuda version ...

run : cuda_pi
	$(RUN) cuda_pi

clean :
	rm -f cuda_pi *~ a.out
