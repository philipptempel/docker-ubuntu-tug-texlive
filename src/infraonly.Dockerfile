ARG TEXLIVE_YEAR
FROM registry.gitlab.com/philipptempel/docker-ubuntu-tug-texlive/$TEXLIVE_YEAR:ubuntu

ARG TEXLIVE_YEAR
ARG TEXLIVE_REPO
ARG TEXLIVE_SCHEME

MAINTAINER Philipp Tempel <docker@philipptempel.me>

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /install
RUN chown -R latex:latex /install
USER latex
ADD texlive.profile texlive.profile
RUN wget --user=anonymous --password=ftp --no-parent --no-verbose $TEXLIVE_REPO/install-tl-unx.tar.gz \
    && tar -xvf install-tl-unx.tar.gz \
    && cd install-tl-*/ \
    && ./install-tl -profile=/install/texlive.profile -repository=$TEXLIVE_REPO/

USER root
RUN rm -rf /install
ENV PATH="/texlive/bin/x86_64-linux:$PATH" \
    MANPATH="/texlive/texmf-dist/doc/man:$MANPATH" \
    INFOPATH="/texlive/texmf-dist/doc/info:$INFOPATH"
ADD latex-paths.sh /etc/profile.d/latex.sh
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

USER latex
WORKDIR /src
ENTRYPOINT ["entrypoint.sh"]
CMD ["tlmgr"]
