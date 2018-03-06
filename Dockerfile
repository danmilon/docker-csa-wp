FROM alpine:3.7
LABEL maintainer="Dan Milon <i@danmilon.me>"

RUN \
 apk add \
    --repository http://dl-cdn.alpinelinux.org/alpine/v3.7/main \
    --no-cache \
    s6 \
    tzdata \
    nginx \
    mariadb \
    php5-fpm \
    php5-mysqli \
    mysql-client

RUN mkdir -p \
 /run/nginx \
 /var/log/nginx \
 /run/mysqld \
 /srv/www/wordpress

RUN \
 chown -R nginx:nginx /run/nginx /var/log/nginx && \
 chown -R mysql:mysql /run/mysqld

RUN \
 cp /usr/share/zoneinfo/Europe/Athens /etc/localtime && \
 echo "Europe/Athens" > /etc/timezone && \
 sed -i "s|;*date.timezone =.*|date.timezone = Europe/Athens|i" /etc/php5/php.ini

COPY root /

EXPOSE 8080

VOLUME ["/var/lib/mysql"]
VOLUME ["/srv/www/wordpress"]

ENTRYPOINT ["/bin/s6-svscan", "/etc/services.d"]
