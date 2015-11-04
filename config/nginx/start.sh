#!/bin/bash
#set -e

sed -ri "s/##NGINX_SERVER_NAME##/${NGINX_SERVER_NAME:-localhost}/" /etc/nginx/conf.d/default.conf

exec "$@"