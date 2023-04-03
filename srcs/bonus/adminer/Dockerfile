FROM debian:buster

# Install packages:
# - php-* - used to run PHP
# - wget - used to download Adminer's dashboard
RUN apt-get update && \
    apt-get install -y php-fpm php-mysql wget

# Create necessary directories:
# - /run/php: used by php-fpm to run the PHP service
RUN mkdir -p /run/php

# Install wp-cli:
# - This tool is a command-line interface for managing WordPress installations;
# - It allows operations such as updating plugins and themes, managing users,
#   performing backups, etc.
RUN wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php && \
    mkdir -p /var/www/html && \
    mv ./adminer-4.8.1.php /var/www/html/index.php

# Alter PHP configuration file so it listens on port 9000 (same as WordPress)
RUN echo "\nlisten = 0.0.0.0:9000" >> /etc/php/7.3/fpm/pool.d/www.conf

# Expose port 9000 for communication with other containers
EXPOSE 9000

# Run php-fpm with -F option*
CMD ["php-fpm7.3", "-F"]

# *The -F option tells php-fpm7.3 to run in the foreground,
# which means that it will log messages to the standard output and error streams normally.
