FROM ubuntu:latest

#####
# Install packages
#####
RUN apt-get -y update && \
    apt-get install -y \
    libpq-dev \
    python3 \
    python3-dev \
    python3-setuptools \
    python3-pip \
    libpcre3-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN pip3 install uwsgi && \
    pip3 install psycopg2

# Add database check script
ADD config/uwsgi/database-check.py /srv/config/database-check.py

#####
# Add uWSGI config
#####
ADD config/uwsgi/django-uwsgi.ini /etc/uwsgi/django-uwsgi.ini
ADD config/uwsgi/setup.sh /srv/config/setup.sh

#####
# Create django user, will own the Django app
#####
RUN chown -R www-data:www-data /srv /etc/uwsgi
WORKDIR /srv

CMD /bin/bash /srv/config/setup.sh