FROM debian:stretch

MAINTAINER Philipp Tempel <mail@philipptempel.me>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -q
RUN apt-get install -qyf --no-install-recommends texlive-full python-pygments
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

