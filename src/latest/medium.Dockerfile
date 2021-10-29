FROM registry.gitlab.com/philipptempel/docker-ubuntu-tug-texlive/latest:small

MAINTAINER Philipp Tempel <docker@philipptempel.me>

ENV DEBIAN_FRONTEND noninteractive

RUN tlmgr install scheme-medium
RUN tlmgr install scheme-medium

RUN luaotfload-tool --cache=erase \
  && luaotfload-tool --update --force \
  && texhash
