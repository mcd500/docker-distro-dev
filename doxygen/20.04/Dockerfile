# docker image only for using doxygen
# separated from other docker image, since it increases the image size
FROM ubuntu:20.04 as builder

# Set the user home dir
ENV USER_DIR=/home/user

# Add a build-user for performing build-steps
# Install sudo
RUN apt-get update \
 && apt-get install -y sudo

# Add the build-user with 
RUN adduser --disabled-password --home ${USER_DIR} --gecos '' build-user 
RUN adduser build-user sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# This is to prevent waiting for key type when installing tzdata
ENV DEBIAN_FRONTEND=noninteractive

# This must executed before any other install or purge, error will occur
RUN apt-get update

# Install packages for doxygen
RUN apt-get install -y build-essential doxygen-latex graphviz texlive-full texlive-latex-base \
  latex-cjk-all make cmake flex bison git

# Change to build-user
USER build-user

# Set to user dir
WORKDIR $USER_DIR

# Set doxygen dir
ENV DOXYGEN_DIR=/home/user/doxygen

# Install doxygen
RUN git clone https://github.com/doxygen/doxygen.git &&  \
  cd $DOXYGEN_DIR &&  \
  mkdir build &&  \
  cd build && \
  cmake -G "Unix Makefiles" .. && \
  make && \
  sudo make install

# Remove doxygen folder
RUN rm -rf $DOXYGEN_DIR

