FROM ubuntu:20.04 as builder

ENV DEBIAN_FRONTEND=noninteractive
ENV USER_DIR=/home/user
ENV KEYSTONE_DIR=${USER}/keystone
ARG DEBUG=1

RUN apt-get update

# required tools to build the keystone

# install toolchain

# second build
FROM ubuntu:20.04 as slim

# Copy only built binaries which would like to keep in docker image
# do not leave large packages of toolchain from keystone in docker image
#COPY --from=builder first second
