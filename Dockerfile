# syntax=docker/dockerfile:1@sha256:865e5dd094beca432e8c0a1d5e1c465db5f998dca4e439981029b3b81fb39ed5

# renovate: datasource=docker depName=opslabhq/alpine
ARG BASE_VERSION=3.20.3@sha256:07ab3daf18f70a8d7983307aa41fd90dd397accbe1989f16ecf1f9f87db08c94

FROM opslabhq/alpine:${BASE_VERSION:-latest} AS base

LABEL maintainer="Anthony Yung <yhs88a@gmail.com>" \
    org.opencontainers.image.source="https://github.com/opslabhqx/alpine-ci"

RUN apk add --no-cache sudo bash git aws-cli curl ca-certificates jq \
    && ln -fs $(which aws) /usr/local/bin/aws-cli

FROM base AS final

RUN mkdir -p /var/cache/apk \
    && ln -fs /var/cache/apk /etc/apk/cache \
    && rm -rf /var/cache/apk/*

USER root
