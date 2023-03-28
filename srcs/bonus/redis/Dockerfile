FROM debian:buster

RUN apt-get update && \
    apt-get install redis -y

COPY ./tools/setup.sh /usr/local/bin

RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 6379

ENTRYPOINT ["setup.sh"]

CMD ["redis-server", "--protected-mode", "no"]