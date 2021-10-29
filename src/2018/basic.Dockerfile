FROM registry.gitlab.com/philipptempel/docker-ubuntu-tug-texlive/2018:minimal

MAINTAINER Philipp Tempel <docker@philipptempel.me>

ENV DEBIAN_FRONTEND noninteractive

RUN tlmgr install scheme-basic
RUN tlmgr install scheme-basic
