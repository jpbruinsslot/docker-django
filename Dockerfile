FROM phusion/baseimage:latest

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
RUN mkdir -p /etc/service/uwsgi
ADD config/uwsgi/django-uwsgi.ini /etc/uwsgi/django-uwsgi.ini
ADD config/uwsgi/setup.sh /etc/service/uwsgi/run
ADD config/uwsgi/reload.sh /srv/config/reload.sh

#####
# www-data will own the Django app
#####
RUN mkdir -p /srv/django
RUN chown -R www-data:www-data /srv /etc/uwsgi
WORKDIR /srv

CMD ["/sbin/my_init"]
