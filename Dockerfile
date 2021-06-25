ARG BASE_CONTAINER=ubuntu:20.04
FROM $BASE_CONTAINER

LABEL maintainer="Ruth Kurniawati <rkurniawati@westfield.ma.edu>"

USER root

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

# this is needed by mpirun
RUN apt --yes -qq --no-install-recommends install ssh

# add mpi.jar into CLASSPATH
ENV CLASSPATH=.:/usr/local/lib/mpi.jar

# set up jupyter

RUN apt install -qq -y --no-install-recommends python3-pip
RUN pip3 install --no-cache-dir jupyter jupyterlab


# Set up the user environment
ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/$NB_USER

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid $NB_UID \
    $NB_USER

COPY . $HOME
RUN chown -R $NB_UID $HOME

USER $NB_USER

# Launch the notebook server
EXPOSE 8888
ENTRYPOINT ["tini", "-g", "--"]
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0"]
