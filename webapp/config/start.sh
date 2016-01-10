#! /bin/bash

# Removed "set -e" because the script database-check.py returns a sys.exit(1)
# when it can't connect to the database. Otherwise this script will exit with
# an error code and the creation of the container will stop


#####
# Postgres: wait until container is created
# 
# $?                most recent foreground pipeline exit status
# > /dev/null 2>&1  get stderr while discarding stdout
#####
python3 /srv/config/database-check.py > /dev/null 2>&1
while [[ $? != 0 ]] ; do
    sleep 5; echo "*** Waiting for postgres container ..."
    python3 /srv/config/database-check.py > /dev/null 2>&1
done


#####
# Django setup
#####

# Django: reset database
# https://docs.djangoproject.com/en/1.9/ref/django-admin/#flush
#
# This will give some errors when there is no database to be flushed, but
# you can ignore these messages.
echo "==> Django setup, executing: flush"
python3 /srv/${DJANGO_PROJECT_NAME}/manage.py flush --noinput

# Django: migrate
#
# Django will see that the tables for the initial migrations already exist
# and mark them as applied without running them. (Django won’t check that the
# table schema match your models, just that the right table names exist).
echo "==> Django setup, executing: migrate"
python3 /srv/${DJANGO_PROJECT_NAME}/manage.py migrate --fake-initial

# Django: collectstatic
echo "==> Django setup, executing: collectstatic"
python3 /srv/${DJANGO_PROJECT_NAME}/manage.py collectstatic --noinput -v 3


#####
# Start uWSGI
#####
echo "==> Starting uWSGI ..."
/usr/local/bin/uwsgi --emperor /etc/uwsgi/django-uwsgi.ini
