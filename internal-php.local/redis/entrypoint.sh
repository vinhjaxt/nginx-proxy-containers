#!/usr/bin/env sh
chown -R redis:redis /var/run/redis
redis-server /usr/local/etc/redis/redis.conf
