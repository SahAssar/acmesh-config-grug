#!/bin/bash -e
export DNS_LOCAL_FILE_DIRECTORY="/var/acme-challenge/"

acme.sh \
  --server letsencrypt \
  --issue \
  -d "$DOMAIN" \
  -d "*.$DOMAIN" \
  --dns dns_local_file \
  --ecc \
  --ocsp

if [ ! -f /etc/maddy-config-grug/certs/$DOMAIN/cert.pem ]; then
  acme.sh \
    --install-cert \
    -d "$DOMAIN" \
    -d "*.$DOMAIN" \
    --cert-file /etc/maddy-config-grug/certs/$DOMAIN/cert.pem \
    --key-file /etc/maddy-config-grug/certs/$DOMAIN/key.pem \
    --fullchain-file /etc/maddy-config-grug/certs/$DOMAIN/fullchain.pem \
    --ca-file /etc/maddy-config-grug/certs/$DOMAIN/ca.pem \
    --ecc \
    --ocsp
fi

if [ ! -f /etc/nginx-config-grug/certs/$DOMAIN/cert.pem ]; then
  acme.sh \
    --install-cert \
    -d "$DOMAIN" \
    -d "*.$DOMAIN" \
    --cert-file /etc/nginx-config-grug/certs/$DOMAIN/cert.pem \
    --key-file /etc/nginx-config-grug/certs/$DOMAIN/key.pem \
    --fullchain-file /etc/nginx-config-grug/certs/$DOMAIN/fullchain.pem \
    --ca-file /etc/nginx-config-grug/certs/$DOMAIN/ca.pem \
    --ecc \
    --ocsp
fi

openssl ocsp \
  -no_nonce \
  -respout /etc/nginx-config-grug/certs/$DOMAIN/ocsp.resp \
  -issuer /etc/nginx-config-grug/certs/$DOMAIN/ca.pem \
  -cert /etc/nginx-config-grug/certs/$DOMAIN/cert.pem \
  -url $(openssl x509 -in /etc/nginx-config-grug/certs/$DOMAIN/cert.pem -text | grep "OCSP - URI:" | cut -d: -f2,3)

for DOMAIN in $DOMAINS; do
  acme.sh \
    --server letsencrypt \
    --issue \
    -d "$DOMAIN" \
    -d "*.$DOMAIN" \
    --dns dns_local_file \
    --ecc \
    --ocsp

  if [ ! -f /etc/maddy-config-grug/certs/$DOMAIN/cert.pem ]; then
    acme.sh \
      --install-cert \
      -d "$DOMAIN" \
      -d "*.$DOMAIN" \
      --cert-file /etc/maddy-config-grug/certs/$DOMAIN/cert.pem \
      --key-file /etc/maddy-config-grug/certs/$DOMAIN/key.pem \
      --fullchain-file /etc/maddy-config-grug/certs/$DOMAIN/fullchain.pem \
      --ca-file /etc/maddy-config-grug/certs/$DOMAIN/ca.pem \
      --ecc \
      --ocsp
  fi

  if [ ! -f /etc/nginx-config-grug/certs/$DOMAIN/cert.pem ]; then
    acme.sh \
      --install-cert \
      -d "$DOMAIN" \
      -d "*.$DOMAIN" \
      --cert-file /etc/nginx-config-grug/certs/$DOMAIN/cert.pem \
      --key-file /etc/nginx-config-grug/certs/$DOMAIN/key.pem \
      --fullchain-file /etc/nginx-config-grug/certs/$DOMAIN/fullchain.pem \
      --ca-file /etc/nginx-config-grug/certs/$DOMAIN/ca.pem \
      --ecc \
      --ocsp
  fi

  openssl ocsp \
    -no_nonce \
    -respout /etc/nginx-config-grug/certs/$DOMAIN/ocsp.resp \
    -issuer /etc/nginx-config-grug/certs/$DOMAIN/ca.pem \
    -cert /etc/nginx-config-grug/certs/$DOMAIN/cert.pem \
    -url $(openssl x509 -in /etc/nginx-config-grug/certs/$DOMAIN/cert.pem -text | grep "OCSP - URI:" | cut -d: -f2,3)
done

acme.sh --cron
