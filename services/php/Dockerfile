FROM php:8.4-fpm

ARG UID=1000
ARG GID=1000

# Crée un utilisateur www
RUN groupadd -g ${GID} www && \
    useradd -u ${UID} -g www -m www

# Installation des dépendances système et des extensions PHP
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zlib1g-dev \
    pkg-config \
    libcurl4-openssl-dev \
    libevent-dev \
    libicu-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql mysqli gd zip \
    # Installation de ext-http via PECL
    && pecl install raphf \
    && pecl install pecl_http \
    && docker-php-ext-enable raphf http \
    # Nettoyage pour réduire la taille de l'image
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

WORKDIR /var/www
USER www
