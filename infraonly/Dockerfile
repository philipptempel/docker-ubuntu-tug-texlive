FROM ubuntu:focal

MAINTAINER Philipp Tempel <docker@philipptempel.me>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qy \
  && apt-get install -qy apt-utils \
  && apt-get upgrade -qy \
  && apt-get dist-upgrade -qy \
  && apt-get update -qy \
  && apt-get install -qy \
  curl \
  perl \
  wget \
  zip \
  git \
  gcc \
  make \
  musl \
  rsync \
  ghostscript \
  imagemagick \
  python-pygments \
  python3-pygments \
  libncurses5 libncurses5-dev libncursesw5-dev


ADD texlive.profile /tmp/texlive/texlive.profile

RUN cd /tmp/texlive/ \
    && wget --user=anonymous --password=ftp --no-parent --no-verbose --recursive --no-directories http://mirrors.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
    && tar -xvf install-tl-unx.tar.gz \
    && cd install-tl-*/ \
    && ./install-tl -profile=/tmp/texlive/texlive.profile -repository=http://mirrors.ctan.org/systems/texlive/tlnet/

ENV PATH="/usr/local/texlive/bin/x86_64-linux/:$PATH" \
  MANPATH="/usr/local/texlive/texmf-dist/doc/man:$MANPATH" \
  INFOPATH="/usr/local/texlive/texmf-dist/doc/info:$INFOPATH"
