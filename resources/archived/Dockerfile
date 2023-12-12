FROM quay.io/jupyterhub/k8s-singleuser-sample:3.2.1
ENV DEBIAN_FRONTEND=noninteractive
ENV NB_USER=jovyan \
    NB_UID=1000 \
    NB_GID=100 \
    HOME=/home/jovyan \
    PATH="${PATH}:/home/jovyan/.local/bin"

COPY requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt
COPY 0-init.py /tmp
COPY connect_template.ipynb /tmp

RUN git clone https://github.com/agapebondservant/client-python-servicebindings.git /tmp/git

USER ${NB_USER}
WORKDIR ${HOME}
EXPOSE 8888
ENTRYPOINT ["tini", "--"]
CMD ["jupyter", "lab"]