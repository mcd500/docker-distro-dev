FROM ubuntu:20.04 as builder

ENV DEBIAN_FRONTEND=noninteractive
ENV USER_DIR=/home/user
ENV SGX_DIR=${USER}/sgx
ARG DEBUG=1

# required tools to build the Intel(R) SGX SDK
RUN apt-get update && \
  apt-get install -y build-essential ocaml ocamlbuild automake autoconf \
  libtool wget python libssl-dev git cmake perl libssl-dev \
  libcurl4-openssl-dev protobuf-compiler libprotobuf-dev debhelper cmake \
  reprepro expect unzip

# install toolchain
  # none for x64

# install packages for doxygen
RUN apt-get install -y doxygen-latex graphviz texlive-full texlive-latex-base \
  latex-cjk-all

# second build
FROM ubuntu:20.04 as slim

# Copy only built binaries which would like to keep in docker image
#COPY --from=builder first second
# none for x64
