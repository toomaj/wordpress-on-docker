# syntax=docker/dockerfile:1
FROM wordpress:cli AS wpcli

FROM wordpress:latest

COPY --from=wpcli /usr/local/bin/wp /usr/local/bin/wp

ENV PATH="/usr/local/bin:${PATH}"
