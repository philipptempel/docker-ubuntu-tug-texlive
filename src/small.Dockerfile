ARG TEXLIVE_YEAR
FROM registry.gitlab.com/philipptempel/docker-ubuntu-tug-texlive/$TEXLIVE_YEAR:basic

MAINTAINER Philipp Tempel <docker@philipptempel.me>

ENV DEBIAN_FRONTEND noninteractive

RUN tlmgr --no-persistent-downloads install scheme-small
RUN tlmgr --no-persistent-downloads install scheme-small

RUN luaotfload-tool --cache=erase \
  && luaotfload-tool --update --force \
  && texhash
