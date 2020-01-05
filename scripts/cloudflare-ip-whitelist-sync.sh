#!/bin/bash

INITIAL_RUN=$1

CLOUDFLARE_FILE_PATH=/etc/nginx/conf.d/00-cloudflare-real-ip.conf

echo "#Cloudflare" > $CLOUDFLARE_FILE_PATH;
echo "" >> $CLOUDFLARE_FILE_PATH;

echo "# - IPv4" >> $CLOUDFLARE_FILE_PATH;
for i in `curl https://www.cloudflare.com/ips-v4`; do
    echo "set_real_ip_from $i;" >> $CLOUDFLARE_FILE_PATH;
done

echo "" >> $CLOUDFLARE_FILE_PATH;
echo "# - IPv6" >> $CLOUDFLARE_FILE_PATH;
for i in `curl https://www.cloudflare.com/ips-v6`; do
    echo "set_real_ip_from $i;" >> $CLOUDFLARE_FILE_PATH;
done

echo "" >> $CLOUDFLARE_FILE_PATH;
echo "real_ip_header CF-Connecting-IP;" >> $CLOUDFLARE_FILE_PATH;
# echo "real_ip_header X-Forwarded-For;" >> $CLOUDFLARE_FILE_PATH;

if [ "$INITIAL_RUN" != "true" ]; then
  #test configuration and reload nginx
  nginx -t && nginx -s reload
fi
