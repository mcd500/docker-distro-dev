#arm64/20.04/Dockerfile
#aistcpsec/tee-distro-dev:arm64-20.04
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

# This is to prevent waiting for key type when installing tzdata
ENV DEBIAN_FRONTEND=noninteractive

# Declare environment variables
ARG DEBUG=1

# This must executed before any other install or purge, error will occur
RUN apt-get update

# install required packages for downloading toolchain
RUN apt-get install -y git make wget curl xz-utils

# Change to user
USER build-user

# Change to base directory
WORKDIR ${USER_DIR}

# Clone the scripts to download
ARG TOOLCHAIN_VERSION=
RUN git clone https://github.com/OP-TEE/build.git -b ${TOOLCHAIN_VERSION}

ENV BUILD_DIR=${USER_DIR}/build
WORKDIR ${BUILD_DIR}

# Installs to ${TOOLCHAIN_ROOT}
ENV OPT_ARM_TC=/opt/arm-tc
ENV TOOLCHAIN_ROOT=${OPT_ARM_TC}
RUN sudo make TOOLCHAIN_ROOT=${OPT_ARM_TC} -f toolchain.mk -j2

# Remove the build directory
RUN rm -rf ${BUILD_DIR}
# Downloaded tar files are remaining under ${TOOLCHAIN_ROOT}
# where untared gcc files colocating, delete them to reduce the
# docker image size
RUN sudo rm -rf ${TOOLCHAIN_ROOT}/*.tar.*

############################################################################
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

# Declare required env variables
ENV DEBIAN_FRONTEND=noninteractive

# This is to enable the installation of i386 binaries
RUN dpkg --add-architecture i386

# This must executed before any other install or purge
RUN apt-get update

# remove snapd which is not required for development
RUN apt-get purge -y snapd snap-confine gir1.2-snapd-1 gnome-software-plugin-snap

# required tools to build the OP-TEE
RUN apt-get install -y android-tools-adb android-tools-fastboot autoconf \
  automake bc bison build-essential ccache cscope curl device-tree-compiler \
  expect flex ftp-upload gdisk iasl libattr1-dev libc6:i386 libcap-dev \
  libfdt-dev libftdi-dev libglib2.0-dev libhidapi-dev libncurses5-dev \
  libpixman-1-dev libssl-dev libstdc++6:i386 libtool libz1:i386 make \
  mtools netcat python python-crypto python3-crypto python-pyelftools \
  python3-pycryptodome python3-pyelftools python3-serial vim-common \
  rsync unzip uuid-dev xdg-utils xterm xz-utils zlib1g-dev \
  git python3-pip wget cpio texlive texinfo cmake \
  # Required packages for setting up the locale
  locales

# Install SUIT Tool
RUN git clone https://git.gitlab.arm.com/research/ietf-suit/suit-tool.git \
 && cd suit-tool  \
 && python3 -m pip install --upgrade .

# Delete old packages
RUN apt-get autoremove -y

# To cope with the problem, https://github.com/OP-TEE/build/issues/424#issuecomment-631302208.
# See also https://qiita.com/suin/items/856bf782d0d295352e51
RUN locale-gen en_US.UTF-8 
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# These two lines will show the debug message by preventing docker cache
#ARG DEBUG_DATE=
#RUN echo ${DEBUG_DATE} > date

# Toolchain directory from first build
ENV OPT_ARM_TC=/opt/arm-tc
ENV TOOLCHAIN_DIR=${OPT_ARM_TC}
# Add toolchain directories to PATH
ENV PATH=${TOOLCHAIN_DIR}/aarch64/bin:${TOOLCHAIN_DIR}/aarch32/bin:${PATH}

# Copy the toolchain directory from first build
COPY --from=builder ${TOOLCHAIN_DIR} ${TOOLCHAIN_DIR}


