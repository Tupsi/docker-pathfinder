. .env
docker-compose exec pfdb /bin/sh -c "unzip -p eve_universe.sql.zip | mysql -u root -p\$MYSQL_ROOT_PASSWORD eve_universe";

