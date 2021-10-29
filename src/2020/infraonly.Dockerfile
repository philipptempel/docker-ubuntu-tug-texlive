FROM ubuntu:xenial

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
  make \
  musl \
  perl \
  python-pygments \
  python3-pygments \
  rsync \
  wget \
  zip

ADD texlive.profile /tmp/texlive/texlive.profile

RUN cd /tmp/texlive/ \
    && wget --user=anonymous --password=ftp --no-parent --no-verbose ftp://tug.org/historic/systems/texlive/2020/tlnet-final/install-tl-unx.tar.gz \
    && tar -xvf install-tl-unx.tar.gz \
    && cd install-tl-*/ \
    && ./install-tl -profile=/tmp/texlive/texlive.profile -repository=ftp://tug.org/historic/systems/texlive/2020/tlnet-final/ \
    && cd /tmp \
    && rm -rf /tmp/texlive

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

RUN echo 'PATH="/usr/local/texlive/bin/x86_64-linux:$PATH"' > /etc/profile.d/latex.sh \
    && echo 'MANPATH="/usr/local/texlive/texmf-dist/doc/man:$MANPATH"' >> /etc/profile.d/latex.sh \
    && echo 'INFOPATH="/usr/local/texlive/texmf-dist/doc/info:$INFOPATH"' >> /etc/profile.d/latex.sh \
    && echo '' >> /etc/profile.d/latex.sh

ENV PATH="/usr/local/texlive/bin/x86_64-linux:$PATH" \
  MANPATH="/usr/local/texlive/texmf-dist/doc/man:$MANPATH" \
  INFOPATH="/usr/local/texlive/texmf-dist/doc/info:$INFOPATH"

WORKDIR /latex
ENTRYPOINT ["entrypoint.sh"]
CMD ["tlmgr"]
