CC = nvcc
RUN = srun -n 1 --gres=gpu:1

SMALL =     100
MEDIUM=   10000
LARGE = 1000000

all: cudapong cuda_small cuda_med cuda_large

cudapong: cudapong.cu
	$(CC) -o cudapong cudapong.cu

cuda_small:cudapong
	$(RUN) cudapong $(SMALL)

cuda_med:cudapong
	$(RUN) cudapong $(MEDIUM)

cuda_large:cudapong
	$(RUN) cudapong $(LARGE)

clean:
	rm -f cudapong *~ a.out
