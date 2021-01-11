#Author: Markus Turba
#Purpose: Pathfinder in Docker. 
#FROM debian:bullseye-slim
FROM debian:bullseye-20201209-slim

# Install basic stuff we need later on
RUN apt-get -y update && apt -y install git nano apache2-utils gettext-base net-tools cron curl sudo

# Install NGINX
RUN apt-get -y update && apt -y install nginx

# Install PHP
RUN apt-get -y install php php-cli php-fpm php-redis php-curl php-gd php-mbstring php-dom php-zip php-mysql
# Redis 5.3.1 doesnt work with Pathfinder, so we install an old one from scratch
#RUN apt-get -y install php-redis
#RUN apt-get -y install php-pear php-dev && no|pecl install redis-5.2.1
RUN apt-get -y install php-pear php-dev && no|pecl install redis-5.2.1 && apt -y remove php-pear php-dev && apt -y autoremove
RUN echo extension=redis.so > /etc/php/7.4/fpm/conf.d/21-redis
RUN echo extension=redis.so > /etc/php/7.4/cli/conf.d/21-redis

# Install old composer, 2.0 is not working with pf
COPY --from=composer:1.6.3 /usr/bin/composer /usr/bin/composer

# Testing stuff to /tmp
#COPY static/index.html /tmp/index.html
#COPY static/default.conf /etc/nginx/sites-enabled/default.conf
#COPY static/test.php /tmp/test.php

RUN rm /etc/nginx/sites-enabled/default && rm -R /etc/nginx/sites-available && mkdir /templates
COPY static/templateNginx.conf /templates/templateNginx.conf
COPY static/templateSite.conf  /templates/templateSite.conf
COPY static/fpm-pool.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY static/crontab.txt /templates/crontab.txt
COPY static/entrypoint.sh   /
COPY static/templatePhp.ini /templates/templatePhp.ini
COPY static/templateEnvironment.ini /templates/templateEnvironment.ini
COPY static/templateConfig.ini /templates/templateConfig.ini

# copy Pathfinder into build
COPY static/pathfinder /var/www/pathfinder
WORKDIR /var/www/pathfinder
RUN mkdir -p /var/www/pathfinder/tmp/cache && chown -R www-data . && chmod -R 0766 logs tmp && touch /etc/nginx/.setup_pass &&  chmod +x /entrypoint.sh

# Run composer install to install the dependencies
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer install --optimize-autoloader --no-interaction --no-progress

EXPOSE 80
CMD cron && service php7.4-fpm start && service nginx start && tail -f /dev/null
ENTRYPOINT ["/entrypoint.sh"]
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1/fpm-ping

