#!/bin/bash

if [ ! -f "identityAccess/src/.env" ]; then 
  if [ -f "identityAccess/src/.env.example" ]; then
    cp identityAccess/src/.env.example identityAccess/src/.env
  fi
fi

if [ ! -f "taskManagement/src/.env" ]; then 
  if [ -f "taskManagement/src/.env.example" ]; then
    cp taskManagement/src/.env.example taskManagement/src/.env
  fi
fi

docker compose up --build -d

sleep 15

docker exec identity chmod -R 775 /var/www/html/identityAccess/src/storage

docker exec identity chmod -R 775 /var/www/html/identityAccess/src/bootstrap/cache

docker exec identity chown -R www-data:www-data /var/www/html/identityAccess/src/storage

docker exec identity chown -R www-data:www-data /var/www/html/identityAccess/src/bootstrap/cache

docker exec identity bash -c "cd /var/www/html/identityAccess/src && composer install"

docker exec identity bash -c "cd /var/www/html/identityAccess/src && php artisan key:generate"

docker exec identity bash -c "cd /var/www/html/identityAccess/src && php artisan migrate"


docker exec task chmod -R 775 /var/www/html/taskManagement/src/storage

docker exec task chmod -R 775 /var/www/html/taskManagement/src/bootstrap/cache

docker exec task chown -R www-data:www-data /var/www/html/taskManagement/src/storage

docker exec task chown -R www-data:www-data /var/www/html/taskManagement/src/bootstrap/cache

docker exec task bash -c "cd /var/www/html/taskManagement/src && composer install"

docker exec task bash -c "cd /var/www/html/taskManagement/src && php artisan key:generate"

docker exec task bash -c "cd /var/www/html/taskManagement/src && php artisan migrate"