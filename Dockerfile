FROM php:8.1.9-fpm-alpine3.16

COPY docker/services/php/php.ini /usr/local/etc/php/php.ini

# зависимости
RUN docker-php-ext-configure opcache --enable-opcache && \
    docker-php-ext-install pdo pdo_mysql && \
    docker-php-ext-install pdo pdo_mysql && \
    apk update && apk add bash unzip git

RUN set -ex \
  && apk --no-cache add \
    postgresql-dev \
    libzip-dev

RUN docker-php-ext-install pdo pdo_pgsql zip

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN find . -type f -exec chmod 664 {} \; && \
    find . -type d -exec chmod 775 {} \; && \
    mkdir -p storage && mkdir -p bootstrap/cache && mkdir -p storage/logs && \
    chmod -R ug+rwx storage bootstrap/cache && \
    chmod -R ug+rwx storage

CMD php-fpm;
