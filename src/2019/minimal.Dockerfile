FROM registry.gitlab.com/philipptempel/docker-ubuntu-tug-texlive/2019:infraonly

MAINTAINER Philipp Tempel <docker@philipptempel.me>

ENV DEBIAN_FRONTEND noninteractive

RUN tlmgr install scheme-minimal && tlmgr install scheme-minimal
