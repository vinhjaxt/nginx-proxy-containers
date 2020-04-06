FROM php:fpm-alpine

RUN apk add --no-cache tzdata
ENV TZ Asia/Ho_Chi_Minh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apk add autoconf gcc make automake g++ make libffi-dev openssl-dev oniguruma-dev

RUN docker-php-ext-install bcmath && docker-php-ext-enable bcmath
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
RUN docker-php-ext-install pdo_mysql && docker-php-ext-enable pdo_mysql

RUN pecl install -o -f redis &&  docker-php-ext-enable redis

RUN set -ex && apk --no-cache add oniguruma-dev
RUN docker-php-ext-install mbstring && docker-php-ext-enable mbstring

RUN docker-php-ext-install pdo && docker-php-ext-enable pdo
RUN set -ex && apk --no-cache add postgresql-dev
RUN docker-php-ext-install pgsql pdo_pgsql && docker-php-ext-enable pgsql pdo_pgsql

RUN rm -rf /tmp/pear

RUN rm -f /usr/local/etc/php-fpm.d/zz-docker.conf /usr/local/etc/php-fpm.d/www.conf
COPY conf/custom-php-fpm.conf /usr/local/etc/php-fpm.d/www.conf

RUN mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

COPY conf/custom-php.ini /usr/local/etc/php/conf.d/vinhjaxt-custom-php.ini

RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /usr/local/etc/php/php.ini /usr/local/etc/php/conf.d/*
