FROM registry.gitlab.com/philipptempel/docker-ubuntu-tug-texlive/latest:basic

MAINTAINER Philipp Tempel <docker@philipptempel.me>

ENV DEBIAN_FRONTEND noninteractive

RUN tlmgr install scheme-small && tlmgr install scheme-small

RUN luaotfload-tool --cache=erase \
  && luaotfload-tool --force \
  && texhash
