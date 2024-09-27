# syntax=docker/dockerfile:1

# renovate: datasource=docker depName=opslabhq/alpine
ARG ALPINE_VERSION=3.20.0

FROM opslabhq/alpine:${ALPINE_VERSION} AS base

LABEL maintainer="Anthony Yung <yhs88a@gmail.com>" \
    org.opencontainers.image.source="https://github.com/opslabhqx/alpine-ci"

RUN apk add --no-cache sudo bash git aws-cli curl ca-certificates jq \
    && ln -s $(which aws) /usr/local/bin/aws-cli

FROM base AS final

RUN mkdir -p /var/cache/apk \
    && ln -s /var/cache/apk /etc/apk/cache \
    && rm -rf /var/cache/apk/*

ARG USER=default
ENV HOME=/home/$USER

RUN adduser -D $USER \
    && echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER \
    && chmod 0440 /etc/sudoers.d/$USER

USER $USER
WORKDIR $HOME
