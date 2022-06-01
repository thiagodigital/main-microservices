#!/bin/bash
echo '==> Create lumen project ***'
docker run --rm --interactive --tty -v $PWD/micro01:/app composer create-project --prefer-dist laravel/lumen ./

echo '==> Uploading Application container ***' 
docker-compose up --build -d

echo '==> Install dependencies ***'
docker run --rm --interactive --tty -v $PWD/micro01:/app composer install

echo '==> Make migrations ***'
docker exec -it php php /var/www/html/artisan migrate

echo '==> Information of new containers ***'
docker ps -a 