#!/usr/bin/env bash
set -e
envsubst '$DOMAIN' </templates/templateSite.conf >/etc/nginx/sites-enabled/pathfinder.conf
envsubst '$CONTAINER_NAME' </templates/templateNginx.conf >/etc/nginx/nginx.conf
envsubst  </templates/templateEnvironment.ini >/var/www/pathfinder/app/environment.ini
envsubst  </templates/templateConfig.ini >/var/www/pathfinder/app/config.ini
envsubst  </templates/templatePhp.ini >/etc/php/7.4/fpm/conf.d/99_pathfinder.ini
htpasswd   -c -b -B  /etc/nginx/.setup_pass "$SETUP_USER" "$SETUP_PASSWORD"
crontab /templates/crontab.txt
chown -R www-data /var/www/pathfinder/
chmod 0766 /var/www/pathfinder/logs /var/www/pathfinder/tmp
exec "$@"
