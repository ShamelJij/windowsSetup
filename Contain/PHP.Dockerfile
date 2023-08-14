FROM php:fpm
RUN apt-get update && apt upgrade -y

RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-enable mysqli

RUN pecl install xdebug && docker-php-ext-enable xdebug 