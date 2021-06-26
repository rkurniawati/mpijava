ARG BASE_CONTAINER=rkurniawati/public:mpijava-base
FROM $BASE_CONTAINER

LABEL maintainer="Ruth Kurniawati <rkurniawati@westfield.ma.edu>"

USER root

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
WORKDIR $HOME
ENTRYPOINT [ "/bin/bash", "-c"]
CMD ["jupyter", "notebook", "--ip", "0.0.0.0"]
