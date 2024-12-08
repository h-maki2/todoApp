#!/bin/bash

if [ ! -f "identityAccess/src/.env" ]; then 
  if [ -f "identityAccess/src/.env.example" ]; then
    cp identityAccess/src/.env.example identityAccess/src/.env
  fi
fi

docker compose up --build -d

sleep 15

docker exec apache chmod -R 775 /var/www/html/identityAccess/src/storage

docker exec apache chmod -R 775 /var/www/html/identityAccess/src/bootstrap/cache

docker exec apache chown -R www-data:www-data /var/www/html/identityAccess/src/storage

docker exec apache chown -R www-data:www-data /var/www/html/identityAccess/src/bootstrap/cache

docker exec apache bash -c "cd /var/www/html/identityAccess/src && composer install"

docker exec apache bash -c "cd /var/www/html/identityAccess/src && php artisan migrate"