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

#  Install the texlive 2017 on Ubuntu 20.04
ENV TEXLIVE_INSTALL_NO_CONTEXT_CACHE=1 \ 
    NOPERLDOC=1

RUN apt-get update && \ 
  apt-get install -y wget unzip tar \ 
  make fontconfig perl openjdk-8-jre libgetopt-long-descriptive-perl \
  libdigest-perl-md5-perl libncurses5 \ 
  python3-pygments && \ 
  rm -rf /var/lib/apt/lists/*

RUN wget https://mirrors.tuna.tsinghua.edu.cn/tex-historic-archive/systems/texlive/2017/tlnet-final/install-tl-unx.tar.gz && \ 
  tar xzf install-tl-unx.tar.gz && rm install-tl-unx.tar.gz && \ 
  cd install-tl* && \ 
  echo "selected_scheme scheme-full" > install.profile && \ 
  echo "tlpdbopt_install_docfiles 0" >> install.profile && \ 
  echo "tlpdbopt_install_srcfiles 0" >> install.profile && \
  echo "tlpdbopt_autobackup 0" >> install.profile && \ 
  echo "tlpdbopt_sys_bin /usr/bin" >> install.profile && \
  ./install-tl -profile install.profile -repository https://mirrors.tuna.tsinghua.edu.cn/tex-historic-archive/systems/texlive/2017/tlnet-final && cd .. && rm -rf install-tl*

RUN /usr/local/texlive/2017/bin/x86_64-linux/tlmgr path add