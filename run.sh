#!/bin/bash
if [ -f .env ]; then
    export $(cat .env | xargs)

    if [ $AUTH_USER == '']; then
        echo '"AUTH_USER" field not found in .env file'
    else
        echo '==> Create lumen project ***'
        docker run --rm --interactive --tty -v $PWD/${AUTH_PATH}:/app composer create-project --prefer-dist laravel/lumen ./

        echo '==> Uploading Application container ***' 
        docker-compose up --build -d

        echo '==> Install dependencies ***'
        docker run --rm --interactive --tty -v $PWD/${AUTH_PATH}:/app composer install
        docker run --rm --interactive --tty -v $PWD/${AUTH_PATH}:/app chown  ${AUTH_USER}:${AUTH_USER} auth-service/*

        echo '==> Install Packages ***'
        docker run --rm --interactive --tty -v $PWD/${AUTH_PATH}:/app composer require wn/lumen-generators

        echo '==> Make migrations ***'
        docker exec -it php php /var/www/html/artisan migrate

        echo '==> Information of new containers ***'
        docker ps -a 
    fi
else
    echo '.env file not found'
fi