FROM php:8.2-cli

# تثبيت التبعيات
RUN apt-get update && apt-get install -y \
    git unzip curl zip libzip-dev libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath gd

# تثبيت Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# إعداد مجلد العمل
WORKDIR /var/www

# نسخ ملفات المشروع
COPY . .

# تثبيت مكتبات Laravel
RUN composer install --no-dev --optimize-autoloader

# إنشاء APP KEY
RUN php artisan key:generate

# ربط مجلد التخزين
RUN php artisan storage:link

# ترحيل قاعدة البيانات (اختياري)
RUN php artisan migrate --force || true

# تشغيل السيرفر
EXPOSE 8000
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
