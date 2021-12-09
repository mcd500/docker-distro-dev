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
  libssl-dev screen device-tree-compiler expect makeself unzip cpio rsync cmake

# install toolchain

# second build
FROM ubuntu:20.04 as slim

# Copy only built binaries which would like to keep in docker image
# do not leave large packages of toolchain from keystone in docker image
#COPY --from=builder first second
