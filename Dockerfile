#FROM jupyterhub/singleuser:latest
FROM gcr.io/sys-2b0109it/demo/bitnami/jupyter-base-notebook:latest
USER root
# Upgrade Python version
ARG PYTHON_VERSION=3.10.6
ARG PYTHON_MAJOR_VERSION=3.10
#RUN apt-get update -y && \
#    apt-get install wget tar build-essential zlib1g-dev -y && \
#    wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
#    tar xvf Python-${PYTHON_VERSION}.tgz && \
#    cd Python-${PYTHON_VERSION} && \
#    ./configure --enable-optimizations && \
#    make altinstall && \
#    /usr/local/bin/python${PYTHON_MAJOR_VERSION} -m pip install --upgrade pip && \
#    pip install --no-cache-dir --user pyservicebinding jupyter_contrib_nbextensions jupyter_nbextensions_configurator
RUN yum update -y && \
    yum groupinstall "Development Tools" -y && \
    yum install wget tar build-essential build-dep zlib1g-dev libncurses5-dev \
        libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev zlib-devel zlib -y && \
    wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz && \
    tar xvf Python-${PYTHON_VERSION}.tgz && \
   cd Python-${PYTHON_VERSION} && \
    ./configure --enable-optimizations && \
    make altinstall && \
    conda install python=${PYTHON_MAJOR_VERSION} && \
    /usr/local/bin/python${PYTHON_MAJOR_VERSION} -m pip install --upgrade pip
RUN pip install --no-cache-dir --user pyservicebinding \
    jupyter_contrib_nbextensions jupyter_nbextensions_configurator
RUN conda clean --all --force-pkgs-dirs -y && \
    conda update python -y && \
    conda install -c conda-forge \
    jupyter_contrib_nbextensions jupyter_nbextensions_configurator \
    numpy pandas matplotlib seaborn tensorflow jupyterhub && \
    chmod -R 777 /opt/bitnami && \
    chmod -R 777 /usr/local/bin/python${PYTHON_MAJOR_VERSION}

USER 1001
RUN jupyter contrib nbextension install --user && \
    jupyter nbextensions_configurator enable --user
CMD ["jupyterhub-singleuser"]