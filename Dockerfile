FROM ubuntu:xenial

MAINTAINER Philipp Tempel <mail@philipptempel.me>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qy \
  && apt-get upgrade -qy \
  && apt-get dist-upgrade -qy

RUN apt-get install -qy \
  perl \
  wget \
  python-pygments

ADD http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz /tmp/
ADD https://gitlab.com/philipptempel/debian-texlive-pygments/raw/patch/ubuntu-16.04/texlive.profile /tmp/texlive.profile

RUN cd /tmp/ \
  && tar -xf install-tl-unx.tar.gz \
  && cd /tmp/install-tl-*/ \
  && ./install-tl -profile=/tmp/texlive.profile
