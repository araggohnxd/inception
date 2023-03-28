#!/bin/sh

# Set shell script directives:
# - e: exit with non-zero value if any command inside script fails
# - x: output each and every command to stdout
set -xe

# If WordPress isn't already configured
if [ ! -f wp-config.php ] || ! grep -q "inception config done" wp-config.php; then
    # Check if WordPress files already exist, and if not, install them
    if wp core download --allow-root 2> /dev/null; then
        # Rename configuration sample file to default configuration file name
        mv wp-config-sample.php wp-config.php
    fi

    wp config set DB_NAME $DB_NAME --allow-root
    wp config set DB_HOST $DB_HOST --allow-root
    wp config set DB_USER $DB_USER_USER --allow-root
    wp config set DB_PASSWORD $DB_USER_PASS --allow-root
    wp config set WP_REDIS_HOST redis --allow-root
    wp config set WP_REDIS_PORT 6379 --raw --allow-root
    wp config set WP_CACHE_KEY_SALT $DOMAIN_NAME --allow-root
    wp plugin install redis-cache --activate --allow-root
    wp plugin update --all --allow-root
    wp redis enable --allow-root
    echo "/* inception config done */" >> wp-config.php
fi

# Execute any commands given to the container
# Defaults to command present in Dockerfile:
# php-fpm7.3 -F
exec "$@"
