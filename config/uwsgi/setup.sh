#! /bin/bash

# Removed "set -e" because the script database-check.py returns a sys.exit(1)
# when it can't connect to the database. Otherwise this script will exit with
# an error code and the creation of the container will stop

chown -R www-data:www-data /srv /run/uwsgi

test ! -z ${DJANGO_PROJECT_NAME} && \
sed -ri "s/##DJANGO_PROJECT_NAME##/${DJANGO_PROJECT_NAME}/" /etc/uwsgi/django-uwsgi.ini
test ! -z ${DJANGO_THREADS} && \
sed -ri "s/##DJANGO_THREADS##/${DJANGO_THREADS}/" /etc/uwsgi/django-uwsgi.ini
test ! -z ${DJANGO_PROCESSES} && \
sed -ri "s/##DJANGO_PROCESSES##/${DJANGO_PROCESSES}/" /etc/uwsgi/django-uwsgi.ini

#####
# Install python requirements
#####

echo "Ensuring dependencies are installed"
# Install application requirements
pip3 install -r /srv/django/$DJANGO_PROJECT_NAME/pip.txt
echo "Dependencies ready"

#####
# Postgres: wait until container is created
#
# $?                most recent foreground pipeline exit status
# > /dev/null 2>&1  get stderr while discarding stdout
#####
python3 /srv/config/database-check.py > /dev/null 2>&1
while [[ $? != 0 ]] ; do
    sleep 1; echo "*** Waiting for postgres container ..."
    python3 /srv/config/database-check.py > /dev/null 2>&1
done


#####
# Django setup
#####

# Django: syncdb
echo "Migrating the DB"
python3 /srv/django/${DJANGO_PROJECT_NAME}/manage.py migrate

# Django: collectstatic
python3 /srv/django/${DJANGO_PROJECT_NAME}/manage.py collectstatic --noinput

echo "Launching the app"
exec /usr/local/bin/uwsgi --emperor /etc/uwsgi --uid www-data --gid www-data
