FROM php:8.0.7-alpine3.13

ADD php.ini /usr/local/etc/php/php.ini

# remove on future
# COPY docker-php-ext-* docker-php-entrypoint /usr/local/bin/

RUN docker-php-ext-enable opcache

RUN docker-php-ext-install pdo_mysql bcmath exif

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"

RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"

RUN php composer-setup.php

RUN php -r "unlink('composer-setup.php');"

RUN chown www-data: composer.phar && mv composer.phar /usr/local/bin/composer

ENTRYPOINT ["docker-php-entrypoint"]

CMD ["php", "-a"]