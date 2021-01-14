. .env
docker-compose exec pfdb /bin/sh -c "unzip -p /export/eve_universe.sql.zip | mysql -u root -p\$MYSQL_ROOT_PASSWORD eve_universe"
docker-compose exec pfdb /bin/sh -c "cat /export/pochven-patch.sql | mysql -u root -p\$MYSQL_ROOT_PASSWORD eve_universe"

