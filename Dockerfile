FROM nginx:alpine

# make sure apt is up to date
RUN ALPINE_VERSION=$(version=$(cat /etc/alpine-release); echo ${version%.*}); \
    echo http://mirror.yandex.ru/mirrors/alpine/v${ALPINE_VERSION}/main > /etc/apk/repositories; \
    echo http://mirror.yandex.ru/mirrors/alpine/v${ALPINE_VERSION}/community >> /etc/apk/repositories
RUN apk add --update curl bash

RUN mkdir -p /opt/scripts

COPY scripts/cloudflare-ip-whitelist-sync.sh /opt/scripts
COPY scripts/allow-cloudflare.sh /opt/scripts

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY scripts/crontab /etc/crontabs/cloudflare

RUN chmod 0600 /etc/crontabs/cloudflare
RUN touch /var/log/cron.log

# RUN /opt/scripts/cloudflare-ip-whitelist-sync.sh true

CMD [ "sh", "-c", "/opt/scripts/cloudflare-ip-whitelist-sync.sh true && /opt/scripts/allow-cloudflare.sh && crond -L /var/log/cron.log && nginx -g 'daemon off;'" ]
