FROM ubuntu:xenial

MAINTAINER Philipp Tempel <mail@philipptempel.me>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qy \
  && apt-get upgrade -qy \
  && apt-get dist-upgrade -qy

RUN apt-get install -qy \
  perl \
  wget \
  ghostscript \
  imagemagick \
  python-pygments \
  gcc \
  make \
  musl \
  rsync

ADD http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz /tmp/
ADD https://raw.githubusercontent.com/philipptempel/docker-ubuntu-tug-texlive/master/texlive.profile /tmp/texlive.profile

RUN cd /tmp/ \
  && tar -xf install-tl-unx.tar.gz \
  && cd /tmp/install-tl-*/ \
  && ./install-tl -profile=/tmp/texlive.profile

ENV PATH="/usr/local/texlive/2017/bin/x86_64-linux/:$PATH" \
  MANPATH="/usr/local/texlive/2017/texmf-dist/doc/man:$MANPATH" \
  INFOPATH="/usr/local/texlive/2017/texmf-dist/doc/info:$INFOPATH"

RUN luaotfload-tool --cache=erase \
  && luaotfload-tool --force \
  && texhash

