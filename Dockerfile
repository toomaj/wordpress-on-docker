# syntax=docker/dockerfile:1
ARG WORDPRESS_CLI_SOURCE_IMAGE=wordpress:cli
ARG WORDPRESS_BASE_IMAGE=wordpress:latest

FROM ${WORDPRESS_CLI_SOURCE_IMAGE} AS wpcli

FROM ${WORDPRESS_BASE_IMAGE}

COPY --from=wpcli /usr/local/bin/wp /usr/local/bin/wp

ENV PATH="/usr/local/bin:${PATH}"
