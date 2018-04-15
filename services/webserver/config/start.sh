#! /bin/bash
DOLLAR='$' envsubst < nginx.tmpl > /etc/nginx/nginx.conf

nginx -g "daemon off;"
