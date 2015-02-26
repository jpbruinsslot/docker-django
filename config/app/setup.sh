#! /bin/bash
set -e

#####
# nginx setup with provided template
#####
j2 /srv/config/nginx/nginx.j2 > /etc/nginx/sites-enabled/default


#####
# Postgres: wait until container is created
#####
echo "Wating before connecting to " $POSTGRES_HOST
sleep 8

#####
# Django setup
#####

# Django: syncdb
python /srv/django/${DJANGO_PROJECT_NAME}/manage.py syncdb --noinput

# Django: collectstatic
python /srv/django/${DJANGO_PROJECT_NAME}/manage.py collectstatic --noinput