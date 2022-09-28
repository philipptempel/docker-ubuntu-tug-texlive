ARG UBUNTU_FLAVOR
FROM ubuntu:$UBUNTU_FLAVOR

MAINTAINER Philipp Tempel <docker@philipptempel.me>

ENV DEBIAN_FRONTEND noninteractive

# Update system
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
      rsync \
      vim \
      wget \
      zip

# Install python3 and pip-requirements
RUN apt-get install \
    --quiet \
    --assume-yes \
      python3 \
      python3-distutils-extra \
      python3-testresources

# Install pip3
WORKDIR /install
RUN { PYTHON3_MAJOR=$(python3 --version 2>&1 | sed 's/.* \([0-9]\).\([0-9]\+\).*/\1/'); } \
    && { PYTHON3_MINOR=$(python3 --version 2>&1 | sed 's/.* \([0-9]\).\([0-9]\+\).*/\2/'); } \
    && { PIP_URL=$([ "${PYTHON3_MINOR}" -le 6 ] && echo "https://bootstrap.pypa.io/pip/${PYTHON3_MAJOR}.${PYTHON3_MINOR}/get-pip.py" || echo "https://bootstrap.pypa.io/pip/get-pip.py"); } \
    && curl -o get-pip.py -sSL "${PIP_URL}" \
    && python3 get-pip.py \
    && pip3 install pygments

# Create user for LaTeX
RUN groupadd \
        --gid=1001 \
        latex \
    && useradd \
        --shell=/usr/bin/bash \
        --uid=1001 \
        --gid=1001 \
        --create-home \
        --password=$(perl -e'print crypt("latex", "latex")') \
        latex

ENV PATH="${HOME}/.local/bin:$PATH"

# Create several directories and give them to user `latex`
RUN mkdir /src /texlive \
    && chown -R latex:latex /src \
    && chown -R latex:latex /texlive
