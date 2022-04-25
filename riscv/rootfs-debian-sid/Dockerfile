FROM ubuntu:20.04

RUN apt-get update && \
  apt-get install -y mmdebstrap qemu-user-static binfmt-support \
  debian-ports-archive-keyring wget gnupg2 xz-utils file

RUN wget -O - https://www.ports.debian.org/archive_2021.key | apt-key add -
RUN wget -O - https://www.ports.debian.org/archive_2022.key | apt-key add -
RUN wget -O - https://www.ports.debian.org/archive_2023.key | apt-key add -
