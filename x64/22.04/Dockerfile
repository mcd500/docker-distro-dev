#x64/22.04/Dockerfile
#aistcpsec/tee-distro-dev:x64-22.04
FROM ubuntu:22.04 as builder

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

# The apt-get update must be executed before any other install or purge, error will occur
# remove snapd which is not required for development
RUN apt-get update && apt-get purge -y snapd snap-confine gir1.2-snapd-1 \
  gnome-software-plugin-snap

# required tools to build the Intel(R) SGX SDK
RUN apt-get install -y build-essential ocaml ocamlbuild automake autoconf \
  libtool wget libssl-dev git cmake perl libssl-dev \
  libcurl4-openssl-dev protobuf-compiler libprotobuf-dev debhelper cmake \
  reprepro expect unzip libcurl4 libprotobuf23 python3-pip curl libcap-dev

# Change to home directory before any clone, etc
WORKDIR ${USER_DIR}

# install toolchain
  # none for x64

# Install SUIT Tool
RUN git clone https://git.gitlab.arm.com/research/ietf-suit/suit-tool.git \
 && cd suit-tool  \
 && python3 -m pip install --upgrade . \
 && cd .. \
 && rm -fr suit-tool

# Delete old packages
RUN apt-get autoremove -y

# Second build is not required for intel sgx
