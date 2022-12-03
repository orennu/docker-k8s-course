# Instructions

1. create src folder in project root directory
2. run 'docker-compose run --rm composer create-project --prefer-dist laravel/laravel:^8.0 .'
3. open src/.env and update the following

DB_HOST=mysql
DB_DATABASE=homestead
DB_USERNAME=homestead
DB_PASSWORD=secret

4. run 'docker-compose up -d --build server'
5. browse to http://localhost:8000
