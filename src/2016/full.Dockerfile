FROM registry.gitlab.com/philipptempel/docker-ubuntu-tug-texlive/2016:medium

MAINTAINER Philipp Tempel <docker@philipptempel.me>

ENV DEBIAN_FRONTEND noninteractive

RUN tlmgr install scheme-full
RUN tlmgr install scheme-full

RUN luaotfload-tool --cache=erase \
  && luaotfload-tool --force \
  && texhash
