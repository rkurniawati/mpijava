FROM ubuntu:20.04

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8


RUN apt --yes -qq update \
 && apt --yes -qq upgrade \
 && apt --yes -qq --no-install-recommends install \
                      build-essential \
                      wget \
                      vim  \
                      openjdk-11-jdk-headless 

RUN wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.1.tar.gz \
	&& tar -xvf openmpi-4.1.1.tar.gz \
  && cd openmpi-4.1.1 && ./configure --enable-mpi-java &&  make all install && ldconfig 

CMD [ "/bin/bash" ]
