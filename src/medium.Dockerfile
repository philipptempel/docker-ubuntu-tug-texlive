ARG TEXLIVE_YEAR
FROM registry.gitlab.com/philipptempel/docker-ubuntu-tug-texlive/$TEXLIVE_YEAR:small

MAINTAINER Philipp Tempel <docker@philipptempel.me>

ENV DEBIAN_FRONTEND noninteractive

RUN tlmgr --no-persistent-downloads install scheme-medium
RUN tlmgr --no-persistent-downloads install scheme-medium

RUN luaotfload-tool --cache=erase \
  && luaotfload-tool --update --force \
  && texhash
