# CUDA 11.8
FROM nvidia/cuda:11.8.0-devel-ubuntu20.04

# Enable shell for source command
SHELL ["/bin/bash", "-c"] 

ENV DEBIAN_FRONTEND=noninteractive

RUN chmod ugo+rwx /home
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
ENV LIBRARY_PATH=/usr/local/cuda/lib64:$LIBRARY_PATH
ENV CUDA_INSTALL_PATH=/usr/local/cuda
RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone

# Install Dependencies
# General
RUN apt-get update && apt-get install -y python3 python3-pip git cmake
# GPGPU-Sim
RUN apt-get install -y build-essential xutils-dev bison zlib1g-dev flex libglu1-mesa-dev
# AerialVision
RUN apt-get install -y python-pmw python-ply python-numpy libpng-dev
# CUDA SDK
RUN apt-get install -y libxi-dev libxmu-dev freeglut3-dev

RUN mkdir /workspace 
# Setup GPGPU-sim
RUN cd /workspace && \
    git clone https://github.com/TerrenceZhangX/gpgpu-sim_distribution && \
    cd ./gpgpu-sim_distribution && \
    git checkout zhangt_dev && \
    source setup_environment && \
    make -j32

# Setup Pytorch