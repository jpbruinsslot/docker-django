#! /bin/bash
set -e
set -x

#####
# nginx setup with provided template
#####
j2 /srv/config/nginx/nginx.j2 > /etc/nginx/sites-enabled/default

#####
# Django setup
#####

# Django: syncdb
python /srv/django/${DJANGO_PROJECT_NAME}/manage.py syncdb --noinput

# Django: collectstatic
python /srv/django/${DJANGO_PROJECT_NAME}/manage.py collectstatic --noinput