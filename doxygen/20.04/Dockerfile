# docker image only for using doxygen
# separated from other docker image, since it increases the image size
FROM ubuntu:20.04 as builder

# This is to prevent waiting for key type when installing tzdata
ENV DEBIAN_FRONTEND=noninteractive
ENV USER_DIR=/home/user

# This must executed before any other install or purge, error will occur
RUN apt-get update

# install packages for doxygen
RUN apt-get install -y doxygen-latex graphviz texlive-full texlive-latex-base \
  latex-cjk-all

# Create a user to build the perform the build step
RUN useradd -rm -d /${USER_DIR}/ -s /bin/bash build-user
# Execute the remaining command as build-user
USER build-user
