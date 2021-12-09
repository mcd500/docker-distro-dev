FROM ubuntu:20.04 as builder

# This is to prevent waiting for key type when installing tzdata
ENV DEBIAN_FRONTEND=noninteractive

ENV USER_DIR=/home/user
ENV OPTEE_DIR=${USER}/optee
ARG DEBUG=1

# This must executed before any other install or purge, error will occur
RUN apt-get update

# required tools to build the OP-TEE

# install toolchain

# second build
FROM ubuntu:20.04 as slim

# Copy only built binaries which would like to keep in docker image
# do not leave large packages of toolchain from keystone in docker image
#COPY --from=builder first second
