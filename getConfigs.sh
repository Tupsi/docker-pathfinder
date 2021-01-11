. .env
docker cp ${CONTAINER_NAME}:/var/www/pathfinder/app/pathfinder.ini conf/pathfinder.ini
docker cp ${CONTAINER_NAME}:/var/www/pathfinder/app/routes.ini conf/routes.ini
docker cp ${CONTAINER_NAME}:/var/www/pathfinder/app/environment.ini conf/environment.ini

