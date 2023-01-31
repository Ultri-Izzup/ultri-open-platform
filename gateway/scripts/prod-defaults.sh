#!/bin/sh
#openssl req -config local.conf -newkey rsa -x509 -days 365 -out local-selfsigned.crt

openssl req -config ./gateway/certs/service.ultri.com.conf -newkey rsa:4096 -nodes -keyout ./gateway/certs/default-service.ultri.com.key -x509 -days 365 -out ./gateway/certs/default-service.ultri.com.pem

openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -out ./gateway/config/account.key