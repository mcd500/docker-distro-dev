FROM ubuntu:22.04 as builder

# Set user directory
ENV USER_DIR=/home/user

# This is to prevent waiting for key type when installing tzdata
ENV DEBIAN_FRONTEND=noninteractive

# This must executed before any other install or purge, error will occur
RUN apt-get update

# required tools to download and unzip the keychain
RUN apt-get install -y wget p7zip-full

# install toolchain
ENV DIST=bionic
ENV TOOLCHAIN_7Z_FILE=riscv-toolchain-lp64d-rv64gc-2021.01.${DIST}.7z
ENV GCC=https://keystone-enclave.eecs.berkeley.edu/files/${TOOLCHAIN_7Z_FILE}
ENV GCC_SHA=https://raw.githubusercontent.com/keystone-enclave/keystone/v1.0.0/.prebuilt_tools_shasums
ENV TOOLCHAIN_DIR=/opt/riscv-tc
ARG DEBUG=1

# Change to home directory before any clone, etc
WORKDIR ${USER_DIR}

RUN mkdir -p ${TOOLCHAIN_DIR}
RUN wget ${GCC} -o /dev/null && \
    wget ${GCC_SHA} && \
    sha256sum -c .prebuilt_tools_shasums --status --ignore-missing
RUN 7za x -y ${TOOLCHAIN_7Z_FILE} "-o${TOOLCHAIN_DIR}" && \
    rm $TOOLCHAIN_7Z_FILE

# Copy only built binaries which would like to keep in docker image
# do not leave large packages of toolchain from keystone in docker image
# second build
FROM ubuntu:22.04 as slim

# Declare required variables
ENV USER_DIR=/home/user

# Add a build-user for performing build-steps
# Install sudo
RUN apt-get update \
 && apt-get install -y sudo

# Add the build-user with 
RUN adduser --disabled-password --home ${USER_DIR} --gecos '' build-user 
RUN adduser build-user sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# This is to prevent waiting for key type when installing tzdata
ENV DEBIAN_FRONTEND=noninteractive

# The apt-get update must be executed before install or purge, since 
# docker cache will used and error will occur
# remove snapd which is not required for development
RUN apt-get update && apt-get purge -y snapd snap-confine gir1.2-snapd-1 \
  gnome-software-plugin-snap

# required tools to build the keystone
RUN apt-get update && apt-get install -y autoconf automake autotools-dev bc bison \
  build-essential curl expat libexpat1-dev flex gawk gcc git gperf libgmp-dev \
  libmpc-dev libmpfr-dev libtool texinfo tmux patchutils zlib1g-dev wget \
  bzip2 patch vim-common lbzip2 python pkg-config libglib2.0-dev libpixman-1-dev \
  libssl-dev screen device-tree-compiler expect makeself unzip cpio rsync cmake \
  p7zip-full python3-pip

# required package for keyedge
RUN apt-get update && \
  # for clang
  apt-get install -y clang-tools-6.0 libclang-6.0-dev cmake \
  # for keedger8r
  ocaml \
  # for make run in ta-ref
  expect screen sshpass

# Change to home directory before any clone, etc
WORKDIR ${USER_DIR}

# Install SUIT Tool
RUN git clone https://git.gitlab.arm.com/research/ietf-suit/suit-tool.git \
 && cd suit-tool  \
 && python3 -m pip install --upgrade . \
 && cd .. \
 && rm -fr suit-tool

# Delete old packages
RUN apt-get autoremove -y

# Declare required variables
ENV TOOLCHAIN_DIR=/opt/riscv-tc
ENV PATH=${TOOLCHAIN_DIR}/bin:$PATH

# Copy the toolchain from first build to here
COPY --from=builder ${TOOLCHAIN_DIR} ${TOOLCHAIN_DIR}

