FROM ubuntu:focal

MAINTAINER Philipp Tempel <docker@philipptempel.me>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    --quiet \
  && apt-get install \
    --quiet \
    --assume-yes \
    apt-utils \
  && apt-get upgrade \
    --quiet \
    --assume-yes \
  && apt-get dist-upgrade \
    --quiet \
    --assume-yes \
  && apt-get update \
    --quiet \
  && apt-get install \
    --quiet \
    --assume-yes \
    curl \
    gcc \
    ghostscript \
    git \
    imagemagick \
    libncurses5 libncurses5-dev libncursesw5-dev \
    make \
    musl \
    perl \
    python-pygments \
    python3-pygments \
    rsync \
    sudo \
    vim \
    wget \
    zip

ADD texlive.profile /tmp/texlive/texlive.profile

RUN cd /tmp/texlive/ \
    && wget --user=anonymous --password=ftp --no-parent --no-verbose http://mirrors.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
    && tar -xvf install-tl-unx.tar.gz \
    && cd install-tl-*/ \
    && ./install-tl -profile=/tmp/texlive/texlive.profile -repository=http://mirrors.ctan.org/systems/texlive/tlnet/ \
    && cd /tmp \
    && rm -rf /tmp/texlive

ENV PATH="/usr/local/texlive/bin/x86_64-linux/:$PATH" \
  MANPATH="/usr/local/texlive/texmf-dist/doc/man:$MANPATH" \
  INFOPATH="/usr/local/texlive/texmf-dist/doc/info:$INFOPATH"
