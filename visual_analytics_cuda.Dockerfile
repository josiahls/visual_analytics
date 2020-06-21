FROM nvidia/cuda:10.0-base-ubuntu18.04
# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8
LABEL com.nvidia.volumes.needed="nvidia_driver"
ENV PATH /opt/conda/bin:$PATH
RUN echo "break"

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates nano curl \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda2-4.5.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

RUN apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean

ENV CONTAINER_USER visual_analytics
ENV CONTAINER_GROUP visual_analytics_group
ENV CONTAINER_UID 1000
# Add user to conda
RUN addgroup --gid $CONTAINER_UID $CONTAINER_GROUP && \
    adduser --uid $CONTAINER_UID --gid $CONTAINER_UID $CONTAINER_USER --disabled-password  && \
    mkdir -p /opt/conda && \
    chown $CONTAINER_USER /opt/conda

USER $CONTAINER_USER
USER root

WORKDIR /opt/project/
RUN chown -R $CONTAINER_USER /opt/project/

# Create Conda env for visual_analytics from environment.yaml
COPY --chown=$CONTAINER_USER:$CONTAINER_GROUP environment.yaml environment.yaml
USER $CONTAINER_USER
RUN conda env create -f environment.yaml

USER root
COPY --chown=$CONTAINER_USER:$CONTAINER_GROUP Summer1_2020_VisualAnalytics5122 .
COPY --chown=$CONTAINER_USER:$CONTAINER_GROUP entrypoint.sh entrypoint.sh
#RUN /bin/bash -c "source activate visual_analytics && pip install kaggle"
RUN ["chmod", "+x", "./entrypoint.sh"]
RUN chown $CONTAINER_USER:$CONTAINER_GROUP entrypoint.sh entrypoint.sh
USER $CONTAINER_USER
ENTRYPOINT ["sh","./entrypoint.sh"]
CMD ["/bin/bash","-c"]

