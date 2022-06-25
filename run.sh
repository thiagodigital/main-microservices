#!/bin/bash
echo '==> Create lumen project ***'
docker run --rm --interactive --tty -v $PWD/api-service:/app composer create-project --prefer-dist laravel/laravel ./

echo '==> Uploading Application container ***'
docker-compose up --build -d

echo '==> Install dependencies ***'
docker run --rm --interactive --tty -v $PWD/api-service:/app composer install

echo '==> Set user folders and group ***'
docker run --rm --interactive --tty -v $PWD/api-service:/app chown thiago:thiago -R .

echo '==> Make migrations ***'
docker exec -it php php /var/www/html/artisan migrate

echo '==> Information of new containers ***'
docker ps -a
