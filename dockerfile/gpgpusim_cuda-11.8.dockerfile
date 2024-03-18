# CUDA 11.8
# https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel-24-02.html
FROM nvcr.io/nvidia/pytorch:22.12-py3
# CUDA 10.2 + pytorch has the bug that pytorch code is running on GPU, instead of simulator. Need further debug to figure out.
# Pytorch 1.4+ calls unimplemented CUDA Runtime API. Needs hack.

# Enable shell for source command
SHELL ["/bin/bash", "-c"] 

ENV DEBIAN_FRONTEND=noninteractive

RUN chmod ugo+rwx /home
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
ENV LIBRARY_PATH=/usr/local/cuda/lib64:$LIBRARY_PATH
ENV CUDA_INSTALL_PATH=/usr/local/cuda
RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone

# Install Dependencies
## General
RUN apt-get update && apt-get install -y python3 python3-pip git wget
### Apt installed cmake is 3.16 version, while pytroch required 3.18+, thus manual install
# RUN wget https://cmake.org/files/v3.22/cmake-3.22.0.tar.gz && \
#     tar -xzvf cmake-3.22.0.tar.gz && \
#     cd cmake-3.22.0 && \
#     ./bootstrap && make -j32 && make install && \
#     rm -r ./cmake-3.22.0 && \
#     export PATH=/usr/local/bin:$PATH
## GPGPU-Sim
RUN apt-get install -y build-essential xutils-dev bison zlib1g-dev flex libglu1-mesa-dev
## AerialVision
RUN apt-get install -y python-pmw python-ply python-numpy libpng-dev
## CUDA SDK
RUN apt-get install -y libxi-dev libxmu-dev freeglut3-dev

# RUN mkdir /workspace 
# Setup GPGPU-sim
## GPGPu-Sim Build
RUN cd /workspace && \
    git clone https://github.com/TerrenceZhangX/gpgpu-sim_distribution && \
    cd ./gpgpu-sim_distribution && \
    git checkout zhangt_dev && \
    source setup_environment && \
    make -j32
ENV LD_LIBRARY_PATH=/workspace/gpgpu-sim_distribution/lib/gcc-9.4.0/cuda-11080/release:$LD_LIBRARY_PATH
## Link Pytorch binary to GPGPU-Sim
ENV PYTORCH_BIN=/usr/local/lib/python3.8/dist-packages/torch/lib/libtorch_cuda.so