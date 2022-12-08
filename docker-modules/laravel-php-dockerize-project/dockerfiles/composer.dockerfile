FROM composer:latest

# ARG USER_ID

# ARG GROUP_ID

# RUN addgroup --gid $GROUP_ID laravel

# RUN adduser --disabled-password --gecos '' --uid $USER_ID -G laravel laravel

RUN addgroup -g 1000 laravel

RUN adduser -G laravel -g laravel -s /bin/sh -D laravel

USER laravel

WORKDIR /var/www/html

ENTRYPOINT [ "composer", "--ignore-platform-reqs" ]