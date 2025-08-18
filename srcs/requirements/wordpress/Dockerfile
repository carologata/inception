FROM debian:oldstable

ARG SERVER_NAME
ARG ROOT_USER
ARG ROOT_PW
ARG ROOT_MAIL
ARG WP_USER
ARG WP_MAIL
ARG WP_PW
ARG WP_DB

RUN apt update && apt install -y \
    lsb-release apt-transport-https ca-certificates wget \
    && wget -qO /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
    && echo "deb https://packages.sury.org/php $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list \
    && apt update && apt install -y \
    php8.1 \
    php8.1-fpm \
    php8.1-mysql \
    mariadb-client \
    wordpress \
    wget \
    && \
    apt clean

RUN wget -O /usr/bin/wp \
    https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod 777 /usr/bin/wp \
    && \
    wp core download --allow-root --path=/var/www/html

RUN mkdir -p /run/php

COPY ./conf/www.conf                        /etc/php/8.1/fpm/pool.d/www.conf
COPY ./conf/wp-config.php                   /var/www/html/wp-config.php
COPY ./tools/init-only-if-mariadb-is-up.sh  /tmp/script.sh

RUN chmod 777 /tmp/script.sh

ENTRYPOINT [ "/tmp/script.sh" ]