#####
# Using docker image by phusion
#
# see: http://phusion.github.io/baseimage-docker/
#####
FROM phusion/baseimage:0.9.16


#####
# Use baseimage-docker's init system.
#####
CMD ["/sbin/my_init"]


#####
# Add code to image
#####
ADD ./code /srv/django


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
    nginx \
    wget


#####
# Download template application
#####
RUN wget \
    https://github.com/erroneousboat/template/raw/master/bin/template \
    -P /usr/local/bin
RUN chmod +x /usr/local/bin/template

#####
# Install python requirements
#####

# Install application requirements
ADD ./config/app/requirements.txt /srv/config/requirements.txt
RUN pip3 install -r /srv/config/requirements.txt

# Add database check script
ADD ./config/app/database-check.py /srv/config/database-check.py


#####
# Install nginx and setup configuration
#####

# daemon mode off, we will run this with supervisor
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Add the nginx configuration file to the container
RUN rm /etc/nginx/sites-enabled/default
ADD ./config/nginx/nginx.tmpl /srv/config/nginx/nginx.tmpl

# Copy SSL certs to location specified in nginx.conf
ADD ./config/nginx/localhost.crt /etc/ssl/certs/localhost.crt
ADD ./config/nginx/localhost.key /etc/ssl/private/localhost.key


#####
# Create django user, will own the Django app
#####
RUN adduser --no-create-home --disabled-login --group --system django
RUN chown -R django:django /srv/django


#####
# Add uWSGI config
#####
ADD ./config/uwsgi/django-uwsgi.ini /etc/uwsgi/django-uwsgi.ini


#####
# Phusion: enable ssh access to container
#
# see: https://github.com/phusion/baseimage-docker#login_ssh
#####

# enable ssh access to container
RUN rm -f /etc/service/sshd/down

# permantly add insecure key
RUN /usr/sbin/enable_insecure_key

# use your own key (when using this comment out the insecure key statement)
# see: https://github.com/phusion/baseimage-docker#using_your_own_key
# ADD .config/ssh/your_key.pub /tmp/your_key.pub
# RUN cat /tmp/your_key.pub >> /root/.ssh/authorized_keys && rm -f /tmp/your_key.pub


#####
# Phusion: add additional scripts that need to run
#####
RUN mkdir -p /etc/my_init.d
ADD ./config/app/setup.sh /etc/my_init.d/setup.sh


#####
# Phusion: add daemons
#####

# Add uwsgi daemon
RUN mkdir /etc/service/uwsgi
ADD ./config/uwsgi/uwsgi.sh /etc/service/uwsgi/run

# Add nginx daemon
RUN mkdir /etc/service/nginx
ADD ./config/nginx/nginx.sh /etc/service/nginx/run


#####
# Phusion: Clean up APT when done.
#####
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
