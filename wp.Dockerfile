# syntax=docker/dockerfile:1.7
FROM wordpress:latest

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install/enable PHP extensions needed by the app
RUN set -eux \
  && docker-php-ext-install -j"$(nproc)" pdo_mysql \
  && docker-php-ext-enable pdo_mysql

# Enable useful Apache modules
RUN set -eux \
  && a2enmod rewrite headers expires

# Install WP-CLI
RUN set -eux \
  && curl -fsSL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp \
  && chmod +x /usr/local/bin/wp \
  && php /usr/local/bin/wp --allow-root --version

# Verify tools are available
RUN set -eux \
  && php -v \
  && composer --version \
  && wp --allow-root --version \
  && php -r "echo 'PDO drivers: ', implode(', ', PDO::getAvailableDrivers()), PHP_EOL; echo 'Extensions: ', implode(', ', get_loaded_extensions()), PHP_EOL;"
