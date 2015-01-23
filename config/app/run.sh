#! /bin/bash

#####
# nginx setup with provided template
#####
j2 /srv/config/nginx.j2 > /etc/nginx/sites-enabled/default

#####
# Postgres setup / database creation
#####
db_host=${DB_HOST:-localhost}
db_name=${DB_NAME:-db_name}
db_user=${DB_USER:-db_user}
db_pass=${DB_PASS:-db_pass}

echo Waiting before connecting to $db_host ...
sleep 8

psql_cmd=`echo psql -U postgres -h $db_host`

echo "Checking for existing database..."
if ! $psql_cmd -l | grep $db_name ; then
    $psql_cmd -c "CREATE DATABASE $db_name;"
    $psql_cmd -c "CREATE USER $db_user WITH password '$db_pass';"
    $psql_cmd -c "GRANT ALL PRIVILEGES ON DATABASE \"$db_name\" to $db_user;"
    echo "Created database $db_name and user $db_user"
fi

#####
# Django setup
#####
python /srv/django/${DJ_PROJECT_NAME}/manage.py syncdb --noinput
# python /srv/django/${DJ_PROJECT_NAME}/manage.py collectstatic --noinput

#####
# Let's go!
#####
supervisord -n