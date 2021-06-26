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

ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

USER $NB_USER

# Launch the notebook server

EXPOSE 8888
WORKDIR $HOME
ENTRYPOINT ["/usr/bin/tini", "--"]

CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0"]

