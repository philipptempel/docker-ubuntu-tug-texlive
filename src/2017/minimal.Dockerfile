FROM philipptempel/docker-ubuntu-tug-texlive:2017-infraonly

MAINTAINER Philipp Tempel <docker@philipptempel.me>

ENV DEBIAN_FRONTEND noninteractive

RUN tlmgr install scheme-minimal && tlmgr install scheme-minimal
