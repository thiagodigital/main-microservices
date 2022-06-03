#!/bin/bash
if [ -f .env ]; then
    export $(cat .env | xargs)

    if [ $SERVICE_NAME == '']; then
        echo '"SERVICE_NAME" field not found in .env file'
    else
        echo '==> Create lumen project ***'
        docker run --rm --interactive --tty -v $PWD/${SERVICE_NAME}:/app composer create-project --prefer-dist laravel/lumen ./

        echo '==> Uploading Application container ***' 
        docker-compose up --build -d

        echo '==> Install dependencies ***'
        docker run --rm --interactive --tty -v $PWD/${SERVICE_NAME}:/app composer install

        echo '==> Make migrations ***'
        docker exec -it php php /var/www/html/artisan migrate

        echo '==> Information of new containers ***'
        docker ps -a 
    fi
else
    echo '.env file not found'
fi