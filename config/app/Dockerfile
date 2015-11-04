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
    wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# add libpcre3 libpcre3-dev for internal routing

#####
# Install python requirements
#####

# Install application requirements
ADD requirements.txt /srv/config/requirements.txt
RUN pip3 install -r /srv/config/requirements.txt

# Add database check script
ADD uwsgi/database-check.py /srv/config/database-check.py

#####
# Add uWSGI config
#####
ADD uwsgi/django-uwsgi.ini /etc/uwsgi/django-uwsgi.ini
ADD uwsgi/setup.sh /srv/config/setup.sh

#####
# Create django user, will own the Django app
#####
RUN chown -R www-data:www-data /srv /etc/uwsgi
WORKDIR /srv

USER www-data

CMD /bin/bash /srv/config/setup.sh