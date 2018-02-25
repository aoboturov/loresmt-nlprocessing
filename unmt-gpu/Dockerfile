FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
MAINTAINER OBOTUROV Artem

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    binutils \
    ca-certificates \
    cmake-data \
    cpp \
    gcc \
    g++ \
    python3-pip \
    python3-setuptools \
    dh-python \
    dpkg-dev \
    libboost-all-dev \
    cmake \
    wget \
    libopenblas-dev \
    swig \
    && \
    rm -rf /var/lib/apt/lists/* && \
  pip3 install --upgrade pip

RUN pip3 install http://download.pytorch.org/whl/cu90/torch-0.3.0.post4-cp35-cp35m-linux_x86_64.whl

RUN mkdir -p /model

# FastText
WORKDIR /model/
RUN git clone https://github.com/facebookresearch/fastText.git --depth 1 && \
    cd fastText && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make -j 16 && \
    make install

WORKDIR /model/
# Moses
RUN git clone https://github.com/moses-smt/mosesdecoder.git --depth 1

# playground will contain user defined scripts, it should be run as:
# docker run -v `pwd`:/data -it basel-baseline
RUN mkdir /data
RUN mkdir /output

RUN git clone https://github.com/aoboturov/UNMT.git --depth 1 && \
  cd UNMT && \
  pip3 install numpy>=1.14.0 gensim==3.2.0 tqdm==4.19.5

WORKDIR /model/

COPY clean-corpus-monolingual.perl /model/
COPY translate.sh /model/

CMD ["/model/translate.sh", "5", "3", "400", "20", "2"]
