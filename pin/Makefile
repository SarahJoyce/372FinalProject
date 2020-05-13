CC = nvcc
RUN = srun -n 4 --gres=gpu:1
SMALL  =        100
MEDIUM =   100000000
LARGE = 10000000000

HOST := $(shell hostname)
ifeq ($(HOST),cisc372)
RUN = srun
endif

all : cuda_pin cuda_small cuda_med cuda_large

cuda_pin : cudapin.cu
	$(CC) -o cuda_pin cudapin.cu

# Add more rules here for running the cuda version ...

cuda_small : cuda_pin
	$(RUN) cuda_pin $(SMALL)

cuda_med : cuda_pin
	$(RUN) cuda_pin $(MEDIUM)

cuda_large : cuda_pin
	$(RUN) cuda_pin $(LARGE)

clean :
	rm -f cuda_pin *~ a.out
