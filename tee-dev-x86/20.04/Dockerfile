FROM ubuntu:20.04 as builder

ENV DEBIAN_FRONTEND=noninteractive
ENV MAIN_DIR=/home/main
ENV LINUX_SGX_DIR=${MAIN_DIR}/linux-sgx
ARG DEBUG=1

RUN apt-get update && \
  # required tools to build the Intel(R) SGX SDK
  apt-get install -y build-essential ocaml ocamlbuild automake autoconf \
  libtool wget python libssl-dev git cmake perl libssl-dev \
  libcurl4-openssl-dev protobuf-compiler libprotobuf-dev debhelper cmake \
  reprepro expect unzip

# second build
FROM ubuntu:20.04 as slim

# Copy only built binaries which would like to keep in docker image
#COPY --from=builder first second
