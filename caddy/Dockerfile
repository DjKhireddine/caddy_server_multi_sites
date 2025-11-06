FROM php:8.3-fpm

ARG UID=1000
ARG GID=1000

# Crée un utilisateur www
RUN groupadd -g ${GID} www && \
    useradd -u ${UID} -g www -m www

# Extensions nécessaires
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zlib1g-dev \
    pkg-config \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql mysqli gd zip

WORKDIR /var/www
USER www

