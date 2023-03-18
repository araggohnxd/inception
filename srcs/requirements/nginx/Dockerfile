FROM debian:buster

RUN apt-get update && \
    apt-get install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=BR/ST=SP/L=Sao Paulo/O=42 School/CN=maolivei.42.fr"

COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# COPY ./nginx.conf /etc/nginx/sites-available/default

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
