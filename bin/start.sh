#!/bin/sh

# Installing pdo_pgsql
if [ ! -f /usr/local/lib/php/extensions/no-debug-non-zts-20170718/pdo_pgsql.so ]; then
    apt update
    apt install -y libpq-dev
    rm -rf /var/lib/apt/*
    docker-php-ext-install -j$(nproc) pdo_pgsql
fi

# Get PHP manual and indexing.
if [ ! -d ./public/doc ]; then
    curl -fL http://jp2.php.net/distributions/manual/php_manual_ja.tar.gz | tar xz -C /tmp
    mv /tmp/php-chunked-xhtml public/doc
    php artisan migrate
    php artisan doc:register
    php artisan term:register
fi

# Generate key when it doesn't exist.
grep .env APP_KEY=base64 >/dev/null 2>&1
if [ $? != 0 ]; then
    php artisan key:generate
fi

# Start artisan serve.
php artisan serve --host=0.0.0.0 --port=8080
