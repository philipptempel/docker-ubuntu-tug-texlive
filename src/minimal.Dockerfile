ARG TEXLIVE_YEAR
FROM registry.gitlab.com/philipptempel/docker-ubuntu-tug-texlive/$TEXLIVE_YEAR:infraonly

MAINTAINER Philipp Tempel <docker@philipptempel.me>

ENV DEBIAN_FRONTEND noninteractive

RUN tlmgr --no-persistent-downloads install scheme-minimal
RUN tlmgr --no-persistent-downloads install scheme-minimal
