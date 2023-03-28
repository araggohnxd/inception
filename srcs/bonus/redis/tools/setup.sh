#!/bin/sh

# Set shell script directives:
# - e: exit with non-zero value if any command inside script fails
# - x: output each and every command to stdout
set -xe

# If Redis isn't already configured
if ! grep -q "inception config done" /etc/redis/redis.conf; then
    # Allow Redis to listen on all available network interfaces, not just localhost
    sed -i "s/bind 127.0.0.1/bind 0.0.0.0/g" /etc/redis/redis.conf

    # Sets the maximum memory that Redis can use to 2 megabytes
    sed -i "s/# maxmemory <bytes>/maxmemory 2mb/g" /etc/redis/redis.conf

    # Sets the policy for what happens when Redis runs out of memory to evict keys based on the least recently used ones
    sed -i "s/# maxmemory-policy noeviction/maxmemory-policy allkeys-lru/g" /etc/redis/redis.conf

    # Add line to Redis configuration file to ensure that configuration is finished in case container crashes
    echo "\n# inception config done" >> /etc/redis/redis.conf
fi

# Execute any commands given to the container
# Defaults to command present in Dockerfile:
# redis-server --protection-mode no
exec "$@"
