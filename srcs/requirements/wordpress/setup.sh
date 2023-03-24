#!/bin/sh

# Set shell script directives:
# - e: exit with non-zero value if any command inside script fails
# - x: output each and every command to stdout
set -xe

# If WordPress isn't already installed
if [ ! -f wp-config.php ]; then
    # Install WordPress using wp-cli
    wp core download --allow-root

    # Set the correct database related variable values to WordPress' configuration file sample
    sed -i "s/database_name_here/$DB_NAME/g" wp-config-sample.php
    sed -i "s/localhost/$DB_HOST/g" wp-config-sample.php
    sed -i "s/username_here/$DB_USER_USER/g" wp-config-sample.php
    sed -i "s/password_here/$DB_USER_PASS/g" wp-config-sample.php
    
    # Rename configuration file sample to default configuration file name
    mv wp-config-sample.php wp-config.php
fi

# Execute any commands given to the container
# Defaults to command present in Dockerfile:
# php-fpm7.3 -F
exec "$@"
