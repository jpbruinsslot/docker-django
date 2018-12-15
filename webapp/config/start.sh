#!/bin/bash
set -e

#####
# Postgres: wait until container is created
#####
until python3 /srv/config/database-check.py; do
    sleep 5; echo "*** Waiting for postgres container ..."
done

#####
# Django setup
#####
if [ "$PRODUCTION" == "true" ]; then
    # Django: migrate
    #
    # Django will see that the tables for the initial migrations already exist
    # and mark them as applied without running them. (Django won’t check that the
    # table schema match your models, just that the right table names exist).
    echo "==> Django setup, executing: migrate"
    python3 /srv/${DJANGO_PROJECT_NAME}/manage.py migrate --fake-initial

    # Django: collectstatic
    #
    # This will upload the files to s3 because of django-storages-redux
    # and the setting:
    # STATICFILES_STORAGE = 'storages.backends.s3boto.S3BotoStorage'
    echo "==> Django setup, executing: collectstatic"
    python3 /srv/${DJANGO_PROJECT_NAME}/manage.py collectstatic --noinput -v 3
else
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
fi


#####
# Start uWSGI
#####
echo "==> Starting uWSGI ..."
/usr/local/bin/uwsgi --emperor /etc/uwsgi/django-uwsgi.ini
