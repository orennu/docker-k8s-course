FROM php:8.1-fpm-alpine

WORKDIR /var/www/html

COPY src .

RUN docker-php-ext-install pdo pdo_mysql

# dev only
RUN addgroup -g 1000 laravel
# dev only
RUN adduser -G laravel -g laravel -s /bin/sh -D laravel

RUN chown -R www-data:www-data /var/www/html
# dev only
USER laravel