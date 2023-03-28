#!/bin/bash

set -xe

if ! grep -q "inception config done" /etc/redis/redis.conf; then
    sed -i "s/bind 127.0.0.1/bind 0.0.0.0/g" /etc/redis/redis.conf
    sed -i "s/# maxmemory <bytes>/maxmemory 2mb/g" /etc/redis/redis.conf
    sed -i "s/# maxmemory-policy noeviction/maxmemory-policy allkeys-lru/g" /etc/redis/redis.conf
    echo "# inception config done" >> /etc/redis/redis.conf
fi

exec "$@"