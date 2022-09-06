#!/usr/bin/env -S /usr/bin/bash -l
if [ -z "$SERVER_DOMAIN" ]
then
  echo "SERVER_DOMAIN not set"
  exit 1
fi
if [ -z "$CERTBOT_EMAIL" ]
then
  echo "CERTBOT_EMAIL not set"
  exit 1
fi
CB_ARCHIVE_DIR="/etc/letsencrypt/archive/"$SERVER_DOMAIN
if [ -d $CB_ARCHIVE_DIR ]
then
  set -e
  # exists, renewing
  certbot $CERTBOT_EXTRA_ARGS renew --standalone -m "$CERTBOT_EMAIL" --agree-tos --no-eff-email --cert-name $SERVER_DOMAIN
else
  set -e
  certbot $CERTBOT_EXTRA_ARGS certonly --standalone -m "$CERTBOT_EMAIL" --agree-tos --no-eff-email -d $SERVER_DOMAIN
fi
