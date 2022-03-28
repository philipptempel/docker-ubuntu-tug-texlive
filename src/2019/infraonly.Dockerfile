FROM ubuntu:bionic

MAINTAINER Philipp Tempel <docker@philipptempel.me>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
      --quiet \
  && apt-get install \
      --quiet \
      --assume-yes \
      apt-utils \
  && apt-get upgrade \
      --quiet \
      --assume-yes \
  && apt-get dist-upgrade \
      --quiet \
      --assume-yes \
  && apt-get update \
      --quiet \
  && apt-get install \
      --quiet \
      --assume-yes \
      curl \
      gcc \
      ghostscript \
      git \
      gnuplot \
      imagemagick \
      lsb-core \
      make \
      musl \
      perl \
      python-pygments \
      python3-pygments \
      rsync \
      wget \
      zip

RUN groupadd \
        --gid=1001 \
        latex\
    && useradd \
        --shell=/usr/bin/bash \
        --uid=1001 \
        --gid=1001 \
        --create-home \
        --password=$(perl -e'print crypt("latex", "latex")') \
        latex \
    && mkdir /texlive \
    && chown -R latex:latex /texlive

ADD common/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ADD --chown=latex:latex 2019/texlive.profile /texlive/texlive.profile
RUN mkdir /src \
    && chown -R latex:latex /src

RUN cd /texlive/ \
    && wget --user=anonymous --password=ftp --no-parent --no-verbose ftp://tug.org/historic/systems/texlive/2019/tlnet-final/install-tl-unx.tar.gz \
    && tar -xvf install-tl-unx.tar.gz \
    && cd install-tl-*/ \
    && ./install-tl -profile=/tmp/texlive/texlive.profile -repository=ftp://tug.org/historic/systems/texlive/2019/tlnet-final/ \
    && cd /texlive \
    && rm -rf /texlive/install-tl-* \
    && rm -rf /texlive/install-tl \
    && rm -rf /texlive/texlive.profile

USER root
ENV PATH="/texlive/bin/x86_64-linux:$PATH" \
    MANPATH="/texlive/texmf-dist/doc/man:$MANPATH" \
    INFOPATH="/texlive/texmf-dist/doc/info:$INFOPATH"
ADD common/latex-paths.sh /etc/profile.d/latex.sh

USER latex
WORKDIR /src
ENTRYPOINT ["entrypoint.sh"]
CMD ["tlmgr"]
