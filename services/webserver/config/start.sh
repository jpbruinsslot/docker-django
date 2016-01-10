#! /bin/bash
template nginx.tmpl:/etc/nginx/nginx.conf

nginx -g "daemon off;"
