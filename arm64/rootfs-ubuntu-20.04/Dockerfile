FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
  apt-get install -y mmdebstrap qemu-user-static binfmt-support \
  debian-ports-archive-keyring wget gnupg2 xz-utils file nodejs nodejs-dev node-gyp libssl1.0-dev npm

