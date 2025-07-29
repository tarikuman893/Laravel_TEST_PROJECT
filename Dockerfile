# syntax=docker/dockerfile:1

# --- PHP + Composer -------------------------------------------------
FROM php:8.4-fpm AS php_base
RUN apt-get update \
 && apt-get install -y git unzip libzip-dev libpng-dev libonig-dev libxml2-dev \
 && docker-php-ext-install pdo_mysql zip

# Composer を取得
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# --- Node -----------------------------------------------------------
# NodeSource の 22.x リポジトリを利用して Node 22 を入れる
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
 && apt-get install -y nodejs

# --- アプリ配置 -----------------------------------------------------
WORKDIR /var/www/html
COPY . .

# PHP/Laravel 依存をインストール
RUN composer install --no-interaction --prefer-dist

# Node 依存をインストール（必要ならコメントアウト解除）
# RUN npm ci && npm run build

# 開発用サーバを起動（0.0.0.0:8000）
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
