FROM nginx

# make sure apt is up to date
RUN apt-get update --fix-missing
RUN apt-get install -y curl cron

RUN mkdir -p /opt/scripts

COPY scripts/cloudflare-ip-whitelist-sync.sh /opt/scripts

COPY scripts/crontab /etc/cron.d/cloudflare
RUN chmod 0644 /etc/cron.d/cloudflare
RUN touch /var/log/cron.log

# RUN /opt/scripts/cloudflare-ip-whitelist-sync.sh true

CMD [ "sh", "-c", "/opt/scripts/cloudflare-ip-whitelist-sync.sh true && cron && nginx -g 'daemon off;'" ]
