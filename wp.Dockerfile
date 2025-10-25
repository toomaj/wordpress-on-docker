# syntax=docker/dockerfile:1.7
FROM wordpress:latest

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install only what's needed for pdo_mysql build (usually none) and enable it
RUN set -eux \
  && docker-php-ext-install -j"$(nproc)" pdo_mysql \
  && docker-php-ext-enable pdo_mysql

# Enable useful Apache modules
RUN set -eux && a2enmod rewrite headers expires

# WP-CLI (optional)
RUN set -eux \
  && curl -fsSL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp \
  && chmod +x /usr/local/bin/wp \
  && php /usr/local/bin/wp --allow-root --version || true

# Build sanity check
RUN php -r "echo 'PDO drivers: ', implode(', ', PDO::getAvailableDrivers()), PHP_EOL; \
            echo 'Extensions: ', implode(', ', get_loaded_extensions()), PHP_EOL;"
