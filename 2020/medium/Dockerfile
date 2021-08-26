FROM philipptempel/docker-ubuntu-tug-texlive:2020-small

MAINTAINER Philipp Tempel <docker@philipptempel.me>

ENV DEBIAN_FRONTEND noninteractive

RUN tlmgr install scheme-medium && tlmgr install scheme-medium

RUN luaotfload-tool --cache=erase \
  && luaotfload-tool --force \
  && texhash
