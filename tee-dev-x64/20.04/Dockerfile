FROM ubuntu:20.04 as builder

ENV DEBIAN_FRONTEND=noninteractive
ENV USER_DIR=/home/user
ENV SGX_DIR=${USER}/sgx
ARG DEBUG=1

RUN apt-get update

# remove snapd which is not required for development
RUN apt-get purge -y snapd snap-confine gir1.2-snapd-1 \
  gnome-software-plugin-snap

# required tools to build the Intel(R) SGX SDK
RUN apt-get install -y build-essential ocaml ocamlbuild automake autoconf \
  libtool wget python libssl-dev git cmake perl libssl-dev \
  libcurl4-openssl-dev protobuf-compiler libprotobuf-dev debhelper cmake \
  reprepro expect unzip

# install toolchain
  # none for x64

# second build
FROM ubuntu:20.04 as slim

# Copy only built binaries which would like to keep in docker image
#COPY --from=builder first second
# none for x64
