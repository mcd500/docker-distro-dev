FROM ubuntu:20.04 as builder

# This is to prevent waiting for key type when installing tzdata
ENV DEBIAN_FRONTEND=noninteractive

ENV USER_DIR=/home/user
ENV OPTEE_DIR=${USER_DIR}/optee
ENV TOOLCHAIN_DIR=/home/user/toolchains
ENV BUILD_DIR=${USER_DIR}/build
ARG DEBUG=1

# This is to enable the installation of i386 binaries
# RUN dpkg --add-architecture i386

# This must executed before any other install or purge, error will occur
RUN apt-get update

# remove snapd which is not required for development
RUN apt-get purge -y snapd snap-confine gir1.2-snapd-1 gnome-software-plugin-snap

# required tools to build the OP-TEE
RUN apt-get install -y git make wget curl xz-utils

# RUN apt-get install -y android-tools-adb android-tools-fastboot autoconf \
#        automake bc bison build-essential ccache codespell \
#        cscope curl device-tree-compiler \
#        expect flex ftp-upload gdisk iasl libattr1-dev libcap-dev \
#        libfdt-dev libftdi-dev libglib2.0-dev libgmp-dev libhidapi-dev \
#        libmpc-dev libncurses5-dev libpixman-1-dev libssl-dev libtool make \
#        mtools netcat ninja-build python-crypto python3-crypto python-pyelftools \
#        python3-pycryptodome python3-pyelftools python3-serial \
#        rsync unzip uuid-dev xdg-utils xterm xz-utils zlib1g-dev \
#        git python3-pip wget cpio texlive texinfo

# Change to base directory
WORKDIR ${USER_DIR}

# Clone the scripts to download
RUN git clone https://github.com/OP-TEE/build.git

WORKDIR ${BUILD_DIR}
RUN make -f ${USER_DIR}/build/toolchain.mk -j2

# Remove the build directory
RUN rm -rf ${USER_DIR}/build 
RUN rm -rf ${TOOLCHAIN_DIR}/*.tar.*

# Second build to have only toolchain directory
FROM ubuntu:20.04 as slim

ENV USER_DIR=/home/user
ENV OPTEE_DIR=${USER_DIR}/optee
ENV TOOLCHAIN_DIR=/home/user/toolchains

COPY --from=builder ${TOOLCHAIN_DIR} ${TOOLCHAIN_DIR}


# Add toolchain directories to PATH
ENV PATH=${TOOLCHAIN_DIR}/aarch64/bin;${TOOLCHAIN_DIR}/aarch32/bin;${PATH}
