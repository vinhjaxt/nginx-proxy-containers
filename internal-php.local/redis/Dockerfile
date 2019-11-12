FROM redis:alpine
RUN mkdir -m 777 -p /var/run/redis
COPY redis.conf /usr/local/etc/redis/redis.conf
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT /entrypoint.sh
