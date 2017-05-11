FROM nginx:mainline-perl

RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y openssl

COPY app.conf /etc/nginx/conf.d/
COPY entrypoint.sh /
COPY nginx.conf /etc/nginx/nginx.conf

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
