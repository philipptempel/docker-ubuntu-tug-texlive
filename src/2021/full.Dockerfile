FROM registry.gitlab.com/philipptempel/docker-ubuntu-tug-texlive/2021:medium

MAINTAINER Philipp Tempel <docker@philipptempel.me>

ENV DEBIAN_FRONTEND noninteractive

RUN tlmgr install scheme-full
RUN tlmgr install scheme-full

RUN luaotfload-tool --cache=erase \
  && luaotfload-tool --update --force \
  && texhash
