#!/bin/sh

if [ "$WEB_USER" ] && [ "$WEB_PASSWORD" ]; then
    printf "${WEB_USER}:`openssl passwd -apr1 $WEB_PASSWORD`\n" >> /etc/nginx/htpasswd
fi

exec nginx -g "daemon off;"