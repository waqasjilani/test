FROM php:7.4-fpm

USER root

WORKDIR /var/www

# Install dependencies
RUN apt-get update \
	# gd
	&& apt-get install -y --no-install-recommends build-essential  openssl nginx libfreetype6-dev libjpeg-dev libpng-dev libwebp-dev zlib1g-dev libzip-dev gcc g++ make vim unzip curl git jpegoptim optipng pngquant gifsicle locales libonig-dev nodejs npm  \
	&& docker-php-ext-configure gd  \
	&& docker-php-ext-install gd \
	# gmp
	&& apt-get install -y --no-install-recommends libgmp-dev \
	&& docker-php-ext-install gmp \
	# pdo_mysql
	&& docker-php-ext-install pdo_mysql mbstring \
	# pdo
	&& docker-php-ext-install pdo \
	# opcache
	&& docker-php-ext-enable opcache \
	# zip
	&& docker-php-ext-install zip \
	&& apt-get autoclean -y \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/pear/
#RUN 

# Copy files
COPY . /var/www

COPY ./deploy/local.ini /usr/local/etc/php/local.ini

COPY ./deploy/nginx.conf /etc/nginx/nginx.conf

RUN chmod +rwx /var/www

RUN chmod -R 777 /var/www

# setup composer and laravel
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN composer install --working-dir="/var/www"

RUN composer dump-autoload --working-dir="/var/www"

#RUN aws s3 COPY s3://tebex-1/var/www

RUN php artisan route:clear

RUN php artisan route:cache

RUN php artisan config:clear

RUN php artisan config:cache

EXPOSE 80

RUN ["chmod", "+x", "post_deploy.sh"]

CMD [ "sh", "./post_deploy.sh" ]
