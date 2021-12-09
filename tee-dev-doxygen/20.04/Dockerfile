# docker image only for using doxygen
# separated from other docker image, since it increases the image size
FROM ubuntu:20.04 as builder

# install packages for doxygen
RUN apt-get install -y doxygen-latex graphviz texlive-full texlive-latex-base \
  latex-cjk-all
