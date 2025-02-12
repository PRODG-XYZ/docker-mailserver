#!/bin/bash

# Configuration - adjust these variables as needed:
DOMAIN="prodg.xyz"
EMAIL="admin@prodg.xyz"
CERT_DIR="/etc/letsencrypt/live/$DOMAIN"

# Obtain new certificate if one does not exist:
if [ ! -d "$CERT_DIR" ]; then
  echo "Obtaining new certificate for $DOMAIN..."
  sudo certbot certonly --standalone \
    --agree-tos \
    --preferred-challenges http \
    --email "$EMAIL" \
    -d "$DOMAIN"
else
  echo "Renewing certificate for $DOMAIN if necessary..."
  sudo certbot renew --non-interactive
fi

# Optionally, trigger a container restart to reload updated certificates:
echo "Restarting the mailserver container..."
docker restart mailserver 