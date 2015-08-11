#! /bin/bash

# Removed "set -e" because the script database-check.py returns a sys.exit(1)
# when it can't connect to the database. Otherwise this script will exit with
# an error code and the creation of the container will stop


#####
# nginx setup with provided template
#####
./usr/local/bin/template /srv/config/nginx/nginx.tmpl:/etc/nginx/sites-enabled/default


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
python3 /srv/django/${DJANGO_PROJECT_NAME}/manage.py migrate

# Django: collectstatic
python3 /srv/django/${DJANGO_PROJECT_NAME}/manage.py collectstatic --noinput
