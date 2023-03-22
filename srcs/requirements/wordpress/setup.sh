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

    # Add root (admin) user to WordPress, set the default URL and website title
    wp core install --allow-root --url=$WP_URL --title=$WP_TITLE --admin_user=$WP_ROOT_USER --admin_password=$WP_ROOT_PASS --admin_email=$WP_ROOT_EMAIL

    # Add second user (user) to Wordpress
	wp user create --allow-root --role=author $WP_USER_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASS
fi

# Execute any commands given to the container
# Defaults to command present in Dockerfile:
# php-fpm7.3 -F
exec "$@"
