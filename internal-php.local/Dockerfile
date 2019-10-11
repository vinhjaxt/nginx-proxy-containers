FROM php:fpm-alpine

RUN apk add autoconf gcc make automake g++ make libffi-dev openssl-dev
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
RUN pecl install -o -f redis \
  &&  docker-php-ext-enable redis

RUN docker-php-ext-install mbstring && docker-php-ext-enable mbstring
RUN rm -rf /tmp/pear

RUN rm -f /usr/local/etc/php-fpm.d/zz-docker.conf /usr/local/etc/php-fpm.d/www.conf
COPY conf/custom-php-fpm.conf /usr/local/etc/php-fpm.d/www.conf

RUN mv /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini

COPY conf/custom-php.ini /usr/local/etc/php/conf.d/vinhjaxt-custom-php.ini

RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /usr/local/etc/php/php.ini /usr/local/etc/php/conf.d/*

