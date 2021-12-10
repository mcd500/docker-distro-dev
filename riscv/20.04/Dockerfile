FROM ubuntu:20.04 as builder

# This is to prevent waiting for key type when installing tzdata
ENV DEBIAN_FRONTEND=noninteractive

ENV USER_DIR=/home/user
ENV KEYSTONE_DIR=${USER}/keystone
ARG DEBUG=1

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

# install toolchain
ENV DIST=bionic
ENV TOOLCHAIN_7Z_FILE=riscv-toolchain-lp64d-rv64gc-2021.01.${DIST}.7z
ENV GCC=https://keystone-enclave.eecs.berkeley.edu/files/${TOOLCHAIN_7Z_FILE}
ENV GCC_SHA=https://raw.githubusercontent.com/keystone-enclave/keystone/v1.0.0/.prebuilt_tools_shasums

ENV TMP_DIR=/home/tmp

RUN mkdir -p ${TMP_DIR}
RUN cd ${TMP_DIR} && wget ${GCC} && \
    wget ${GCC_SHA} && \
    sha256sum -c .prebuilt_tools_shasums --status --ignore-missing
RUN cd ${TMP_DIR} && 7za x -y ${TOOLCHAIN_7Z_FILE} -o${TOOLCHAIN_DIR} && \
    rm $TOOLCHAIN_7Z_FILE

# second build
FROM ubuntu:20.04 as slim

# Copy only built binaries which would like to keep in docker image
# do not leave large packages of toolchain from keystone in docker image

ENV USER_DIR=/home/user
ENV TOOLCHAIN_DIR=/home/user/toolchain
ENV KEYSTONE_DIR=${USER}/keystone
ENV PATH=${TOOLCHAIN_DIR}/bin:$PATH
WORKDIR ${USER_DIR}

COPY --from=builder ${TOOLCHAIN_DIR} ${TOOLCHAIN_DIR}
