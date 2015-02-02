#! /bin/bash
set -e
set -x

#####
# nginx setup with provided template
#####
j2 /srv/config/nginx/nginx.j2 > /etc/nginx/sites-enabled/webapp.conf


#####
# Django setup
#####

# Phusion: setup that passenger needs for wsgi applications
DIR="/home/app/${DJANGO_PROJECT_NAME}/public"
if [ ! -d $DIR ]; then
    echo "creating folder $DIR"
    mkdir /home/app/${DJANGO_PROJECT_NAME}/public
fi
j2 /srv/config/app/passenger_wsgi.j2  > /home/app/${DJANGO_PROJECT_NAME}/passenger_wsgi.py

# Django: syncdb
python /home/app/${DJANGO_PROJECT_NAME}/manage.py syncdb --noinput

# Django: collectstatic
python /home/app/${DJANGO_PROJECT_NAME}/manage.py collectstatic --noinput