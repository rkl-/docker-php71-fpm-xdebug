FROM php:7.1-fpm
MAINTAINER Romano Kleinwaechter

RUN apt-get update && \
  apt-get install \
    git \
    zip \
    unzip \
    zlib1g-dev \
  -y

RUN docker-php-ext-install zip pdo_mysql

RUN pecl install \
  xdebug \

  && \

  docker-php-ext-enable \
    xdebug

# Upload sizes
RUN \
  echo ''                                              >> /usr/local/etc/php-fpm.d/www.conf && \
  echo ''                                              >> /usr/local/etc/php-fpm.d/docker.conf && \
  echo 'php_admin_value[post_max_size] = 10M'          >> /usr/local/etc/php-fpm.d/www.conf && \
  echo 'php_admin_value[post_max_size] = 10M'          >> /usr/local/etc/php-fpm.d/docker.conf && \
  echo 'php_admin_value[upload_max_filesize] = 10M'    >> /usr/local/etc/php-fpm.d/www.conf && \
  echo 'php_admin_value[upload_max_filesize] = 10M'    >> /usr/local/etc/php-fpm.d/docker.conf

# install composer
RUN cd /tmp \
  && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php composer-setup.php --filename=composer --install-dir=/usr/local/bin \
  && unlink composer-setup.php

# disbale xdebug for composer
RUN mkdir /usr/local/etc/php/conf.d.noxdebug \
  && ln -s /usr/local/etc/php/conf.d/* /usr/local/etc/php/conf.d.noxdebug/ \
  && unlink /usr/local/etc/php/conf.d.noxdebug/docker-php-ext-xdebug.ini \
  && echo "alias composer='PHP_INI_SCAN_DIR=/etc/php.d.noxdebug/ /usr/local/bin/composer'" >> /etc/bashrc

# change php-fpm port
RUN find /usr/local/etc/php-fpm.d/ -type f -exec sed -i 's/9000/9999/g' "{}" \;

# cleanup
RUN apt-get autoremove -y && apt-get autoclean
