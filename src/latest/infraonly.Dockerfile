FROM ubuntu:focal

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
      imagemagick \
      libncurses5 libncurses5-dev libncursesw5-dev \
      lsb-core \
      make \
      musl \
      perl \
      python-pygments \
      python3-pygments \
      rsync \
      sudo \
      vim \
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
    && mkdir -p /texlive/install \
    && chown -R latex:latex /texlive

COPY common/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ADD --chown=latex:latex latest/texlive.profile /texlive/install/texlive.profile
RUN mkdir /src \
    && chown -R latex:latex /src

USER latex
RUN cd /texlive/install/ \
    && wget --user=anonymous --password=ftp --no-parent --no-verbose http://mirrors.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
    && tar -xvf install-tl-unx.tar.gz \
    && cd install-tl-*/ \
    && ./install-tl -profile=/texlive/install/texlive.profile -repository=http://mirrors.ctan.org/systems/texlive/tlnet/ \
    && cd /texlive \
    && rm -rf /texlive/install

USER root
ENV PATH="/texlive/bin/x86_64-linux:$PATH" \
    MANPATH="/texlive/texmf-dist/doc/man:$MANPATH" \
    INFOPATH="/texlive/texmf-dist/doc/info:$INFOPATH"
ADD common/latex-paths.sh /etc/profile.d/latex.sh

USER latex
WORKDIR /src
ENTRYPOINT ["entrypoint.sh"]
CMD ["tlmgr"]
