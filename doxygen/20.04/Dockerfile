# docker image only for using doxygen
# separated from other docker image, since it increases the image size
FROM ubuntu:20.04 as builder

# This is to prevent waiting for key type when installing tzdata
ENV DEBIAN_FRONTEND=noninteractive
ENV USER_DIR=/home/user


# Add a build-user for performing build-steps
# Install sudo
RUN apt-get update \
 && apt-get install -y sudo

# Add the build-user with 
RUN adduser --disabled-password --home ${USER_DIR} --gecos '' build-user 
RUN adduser build-user sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# From now on, run as build-user
USER build-user

# This must executed before any other install or purge, error will occur
RUN sudo apt-get update

# install packages for doxygen
RUN sudo apt-get install -y doxygen-latex graphviz texlive-full texlive-latex-base \
  latex-cjk-all