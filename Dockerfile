# syntax=docker/dockerfile:1.1.7-experimental
######################
# Base builder image #
######################
FROM ubuntu:22.04 as base

ENV \
  # locale
  LC_ALL=C.UTF-8 \
  # python:
  PYTHONFAULTHANDLER=1 \
  PYTHONUNBUFFERED=1 \
  PYTHONHASHSEED=random \
  # pip:
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100 \
  # debconf
  DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
        mumble-server \
        certbot \
        tini \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && true

COPY --from=hairyhenderson/gomplate:stable /gomplate /bin/gomplate
SHELL ["/bin/bash", "-lc"]

###################
# Server instance #
###################
FROM base as server
# Copy entrypoint script and use tini to launch it
COPY ./docker/entrypoint-full.sh /entrypoint.sh
COPY ./scripts/ /murmurdata/scripts/
COPY ./templates/ /murmurdata/templates/
RUN mkdir -p /murmurdata/logs \
    && chown -R mumble-server:mumble-server /murmurdata \
    && true
VOLUME ["/murmurdata", "/etc/letsencrypt"]
# port 80 is for certbot
EXPOSE 64738/tcp 64738/udp 80/tcp
ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]


###########
# Hacking #
###########
FROM base as devel_shell
RUN apt-get update && apt-get install -y zsh vim python3-pip\
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    && echo "source /root/.profile" >>/root/.zshrc \
    && echo "export EDITOR=vim" >>/root/.profile \
    && pip3 install git-up \
    && true
ENTRYPOINT ["/bin/zsh", "-l"]
