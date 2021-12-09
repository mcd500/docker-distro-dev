FROM ubuntu:20.04 as builder

ENV DEBIAN_FRONTEND=noninteractive
ENV USER_DIR=/home/user
ENV KEYSTONE_DIR=${USER}/keystone
ARG DEBUG=1

# required tools to build the keystone
RUN apt-get update

# install toolchain

# install packages for doxygen
RUN apt-get install -y doxygen-latex graphviz texlive-full texlive-latex-base \
  latex-cjk-all

# second build
FROM ubuntu:20.04 as slim

# Copy only built binaries which would like to keep in docker image
# do not leave large packages of toolchain from keystone in docker image
#COPY --from=builder first second
