FROM debian:buster

RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client

RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 755 /var/run/mysqld

COPY ./setup.sh /usr/local/bin

RUN chmod +x /usr/local/bin/setup.sh

COPY ./dump.sql /tmp

EXPOSE 3306

ENTRYPOINT ["setup.sh"]

CMD ["mysqld", "--bind-address=0.0.0.0"]
