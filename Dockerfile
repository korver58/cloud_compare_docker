FROM ubuntu:20.04

ARG UID=1000
ARG USER=developer
RUN useradd -m -u ${UID} ${USER}
ENV DEBIAN_FRONTEND=noninteractive \
    HOME=/home/${USER}/
WORKDIR ${HOME}

RUN apt-get update && apt-get install -y \
    curl wget git build-essential cmake \
    # https://github.com/CloudCompare/CloudCompare/blob/master/BUILD.md
    libqt5svg5-dev libqt5opengl5-dev qt5-default qttools5-dev qttools5-dev-tools libqt5websockets5-dev \
    # for qE57IO
    libxerces-c-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# build cloud compare
# COPY --chown=${USER} .CloudCompare ${HOME}/CloudCompare
RUN git clone --recursive https://github.com/cloudcompare/CloudCompare.git
RUN mkdir -p CloudCompare/build && cd CloudCompare/build \
    && cmake \
    # -D OPTION_USE_GDAL=ON \
    -D PLUGIN_IO_QE57=ON \
    # -D PLUGIN_IO_QFBX=ON \
    # -D PLUGIN_IO_QPDAL=ON \
    .. \
    && cmake --build . \
    && cmake --install .

USER ${USER}
CMD ["/bin/bash"]