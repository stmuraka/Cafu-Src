FROM ubuntu:xenial
MAINTAINER Shaun Murakami <stmuraka@us.ibm.com>

# Install components
RUN apt-get -y update \
 && apt-get -y install \
        apt-utils \
        git \
        gitk \
        build-essential \
        libgtk2.0-dev \
        libgl1-mesa-dev \
        libglu1-mesa-dev \
        libasound2-dev \
        g++ \
        scons \
        python2.7 \
        unzip \
# Cleanup package files
 && apt-get autoremove  \
 && apt-get autoclean

WORKDIR /root/
ARG CAFU_SRC
ENV CAFU_SRC ${CAFU_SRC:-"https://bitbucket.org/cafu/cafu.git"}

RUN git clone --recursive ${CAFU_SRC} Cafu


# Download binary assets
ARG TEXTURES_SRC
ENV TEXTURES_SRC ${TEXTURES_SRC:-"http://www.cafu.de/files/Textures.zip"}
ADD ${TEXTURES_SRC} /root/Cafu/Games/DeathMatch/

ARG WORLDS_SRC
ENV WORLDS_SRC ${WORLDS_SRC:-"http://www.cafu.de/files/Worlds.zip"}
ADD ${WORLDS_SRC} /root/Cafu/Games/DeathMatch/

RUN cd /root/Cafu/Games/DeathMatch/ \
 && unzip *.zip \
 && rm *.zip


# Compile Cafu - use half of the number of total processors
RUN scons -j $((($(cat /proc/cpuinfo | grep processor | wc -l) / 2)))

WORKDIR /root/Cafu
CMD love $(find . -name "*.love")
