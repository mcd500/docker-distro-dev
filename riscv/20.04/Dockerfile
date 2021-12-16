FROM ubuntu:20.04 as builder

# This is to prevent waiting for key type when installing tzdata
ENV DEBIAN_FRONTEND=noninteractive

# Declare required env variables
ENV USER_DIR=/home/user
ARG DEBUG=1

# This must executed before any other install or purge, error will occur
RUN apt-get update

# required tools to download and unzip the keychain
RUN apt-get install -y wget p7zip-full

# install toolchain
ENV DIST=bionic
ENV TOOLCHAIN_7Z_FILE=riscv-toolchain-lp64d-rv64gc-2021.01.${DIST}.7z
ENV GCC=https://keystone-enclave.eecs.berkeley.edu/files/${TOOLCHAIN_7Z_FILE}
ENV GCC_SHA=https://raw.githubusercontent.com/keystone-enclave/keystone/v1.0.0/.prebuilt_tools_shasums
ENV TOOLCHAIN_DIR=/home/user/toolchain
ENV TMP_DIR=/home/tmp

# Create a user to build the perform the build step
RUN useradd -rm -d /${USER_DIR}/ -s /bin/bash build-user
# Execute the remaining command as build-user
USER build-user

RUN mkdir -p ${TMP_DIR}
RUN cd ${TMP_DIR} && wget ${GCC} -o /dev/null && \
    wget ${GCC_SHA} && \
    sha256sum -c .prebuilt_tools_shasums --status --ignore-missing
RUN cd ${TMP_DIR} && 7za x -y ${TOOLCHAIN_7Z_FILE} "-o${TOOLCHAIN_DIR}" && \
    rm $TOOLCHAIN_7Z_FILE

# Copy only built binaries which would like to keep in docker image
# do not leave large packages of toolchain from keystone in docker image
# second build
FROM ubuntu:20.04 as slim

# Declare required variables
ENV USER_DIR=/home/user
ENV KEYSTONE_DIR=${USER}/keystone
ENV TOOLCHAIN_DIR=/home/user/toolchain
ENV PATH=${TOOLCHAIN_DIR}/bin:$PATH

# Change to user directory
WORKDIR ${USER_DIR}

# This is to prevent waiting for key type when installing tzdata
ENV DEBIAN_FRONTEND=noninteractive

# This must executed before any other install or purge, error will occur
RUN apt-get update

# remove snapd which is not required for development
RUN apt-get purge -y snapd snap-confine gir1.2-snapd-1 \
  gnome-software-plugin-snap

# required tools to build the keystone
RUN apt-get install -y autoconf automake autotools-dev bc bison \
  build-essential curl expat libexpat1-dev flex gawk gcc git gperf libgmp-dev \
  libmpc-dev libmpfr-dev libtool texinfo tmux patchutils zlib1g-dev wget \
  bzip2 patch vim-common lbzip2 python pkg-config libglib2.0-dev libpixman-1-dev \
  libssl-dev screen device-tree-compiler expect makeself unzip cpio rsync cmake \
  p7zip-full

# required package for keyedge
RUN apt-get update && \
  # for clang
  apt-get install -y clang-tools-6.0 libclang-6.0-dev cmake \
  # for keedger8r
  ocaml \
  # for make run in ta-ref
  expect screen sshpass

# Copy the toolchain from first build to here
COPY --from=builder ${TOOLCHAIN_DIR} ${TOOLCHAIN_DIR}

# Create a user to build the perform the build step
RUN useradd -rm -d /${USER_DIR}/ -s /bin/bash build-user
# Execute the remaining command as build-user
USER build-user
