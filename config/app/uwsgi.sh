#!/bin/sh
set -e
set -x

/usr/local/bin/uwsgi --emperor /etc/uwsgi/django-uwsgi.ini