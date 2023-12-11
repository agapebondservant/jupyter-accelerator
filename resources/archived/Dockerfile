FROM quay.io/jupyterhub/k8s-singleuser-sample:3.2.1
ENV DEBIAN_FRONTEND=noninteractive
ENV NB_USER=jovyan \
    NB_UID=1000 \
    NB_GID=100 \
    HOME=/home/jovyan

COPY requirements.txt /tmp/requirements.txt
RUN apt-get install libpq-dev git -y \
&& git clone https://github.com/agapebondservant/client-python-servicebindings.git /tmp/git \
&& pip install -r /tmp/requirements.txt

COPY 0-init.py /tmp

WORKDIR ${HOME}
USER ${NB_USER}

EXPOSE 8888
ENTRYPOINT ["tini", "--"]
CMD ["jupyter", "lab"]