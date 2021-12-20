FROM ubuntu:20.04 as builder

# Set user directory
ENV USER_DIR=/home/user

# Add a build-user for performing build-steps
# Install sudo
RUN apt-get update \
 && apt-get install -y sudo

# Add the build-user with 
RUN adduser --disabled-password --home ${USER_DIR} --gecos '' build-user 
RUN adduser build-user sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# From now on, run as build-user
USER build-user

# This is to prevent waiting for key type when installing tzdata
ENV DEBIAN_FRONTEND=noninteractive

# Declare environment variables
ENV USER_DIR=/home/user
ENV OPTEE_DIR=${USER_DIR}/optee
ENV TOOLCHAIN_DIR=/home/user/toolchains
ENV BUILD_DIR=${USER_DIR}/build
ARG DEBUG=1

# This must executed before any other install or purge, error will occur
RUN sudo apt-get update

# install required packages for downloading toolchain
RUN sudo apt-get install -y git make wget curl xz-utils

# Change to base directory
WORKDIR ${USER_DIR}

# Clone the scripts to download
ARG TOOLCHAIN_VERSION=
RUN git clone https://github.com/OP-TEE/build.git -b ${TOOLCHAIN_VERSION}

WORKDIR ${BUILD_DIR}
RUN make -f ${USER_DIR}/build/toolchain.mk -j2

# Remove the build directory
RUN rm -rf ${USER_DIR}/build 
RUN rm -rf ${TOOLCHAIN_DIR}/*.tar.*

# Second build to have only toolchain directory and required packages
FROM ubuntu:20.04 as slim

# Declare required env variables
ENV USER_DIR=/home/user

# Add a build-user for performing build-steps
# Install sudo
RUN apt-get update \
 && apt-get install -y sudo

# Add the build-user with 
RUN adduser --disabled-password --home ${USER_DIR} --gecos '' build-user 
RUN adduser build-user sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# From now on, run as build-user
USER build-user

# Declare required env variables
ENV DEBIAN_FRONTEND=noninteractive
ENV USER_DIR=/home/user
ENV OPTEE_DIR=${USER_DIR}/optee
ENV TOOLCHAIN_DIR=/home/user/toolchains

# This is to enable the installation of i386 binaries
RUN sudo dpkg --add-architecture i386

# This must executed before any other install or purge
RUN sudo apt-get update

# remove snapd which is not required for development
RUN sudo apt-get purge -y snapd snap-confine gir1.2-snapd-1 gnome-software-plugin-snap

# required tools to build the OP-TEE
RUN sudo apt-get install -y android-tools-adb android-tools-fastboot autoconf \
  automake bc bison build-essential ccache cscope curl device-tree-compiler \
  expect flex ftp-upload gdisk iasl libattr1-dev libc6:i386 libcap-dev \
  libfdt-dev libftdi-dev libglib2.0-dev libhidapi-dev libncurses5-dev \
  libpixman-1-dev libssl-dev libstdc++6:i386 libtool libz1:i386 make \
  mtools netcat python python-crypto python3-crypto python-pyelftools \
  python3-pycryptodome python3-pyelftools python3-serial vim-common \
  rsync unzip uuid-dev xdg-utils xterm xz-utils zlib1g-dev \
  git python3-pip wget cpio texlive texinfo \
  # Required packages for setting up the locale
  locales

# copy the toolchain directory from first build 
COPY --from=builder ${TOOLCHAIN_DIR} ${TOOLCHAIN_DIR}

# Add toolchain directories to PATH
ENV PATH=${TOOLCHAIN_DIR}/aarch64/bin;${TOOLCHAIN_DIR}/aarch32/bin;${PATH}

# To cope with the problem, https://github.com/OP-TEE/build/issues/424#issuecomment-631302208.
# See also https://qiita.com/suin/items/856bf782d0d295352e51
RUN locale-gen en_US.UTF-8 
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
