FROM debian:buster

# Set the working directory to /var/www/html, which is WordPress' default
WORKDIR /var/www/html

# Install packages:
# - php-* - used to run WordPress
# - wget - used to install wp-cli
# - tar - used to unpack wp-cli's tarball
RUN apt-get update && \
    apt-get install -y php-fpm php-mysql wget tar

# Create necessary directories:
# - /run/php: used by php-fpm to run the PHP service
RUN mkdir -p /run/php

# Install wp-cli:
# - This tool is a command-line interface for managing WordPress installations;
# - It allows operations such as updating plugins and themes, managing users, 
#   performing backups, etc.
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp

# Copy php-fpm's configuration file to the appropriate path:
# - This file is used by php-fpm to manage PHP processes;
# - It contains settings such as number of child processes, user, group, port, etc.
COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/www.conf

# Copy setup script to local bin directory
COPY ./tools/setup.sh /usr/local/bin

# Change setup script permissions so it becomes executable
RUN chmod +x /usr/local/bin/setup.sh

# Expose port 9000 for communication with other containers
EXPOSE 9000

# Set entrypoint to be setup script
ENTRYPOINT ["setup.sh"]

# Run php-fpm with -F option*
CMD ["php-fpm7.3", "-F"]

# *The -F option tells php-fpm7.3 to run in the foreground, 
# which means that it will log messages to the standard output and error streams normally.