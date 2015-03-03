#####
# Using docker image by phusion see: https://github.com/phusion/passenger-docker
#####
FROM phusion/passenger-customizable:0.9.15


#####
# Use baseimage-docker's init system.
#####
CMD ["/sbin/my_init"]


#####
# Phusion: add code to image
#####
ADD ./code /home/app
RUN chown -R app:app /home/app


#####
# Install packages
#####
RUN apt-get -y update && \
    apt-get install -y \
    build-essential \
    libpq-dev \
    git-core \
    curl \
    tmux \
    vim \
    wget \
    nodejs \
    python \
    python-dev \
    python-setuptools


#####
# Install and setup PIP and install requirements
#####

# Install pip
RUN easy_install pip

# Install application requirements
ADD ./config/app/requirements.txt /srv/config/app/requirements.txt
RUN pip install -r /srv/config/app/requirements.txt

# Add database check script
ADD ./config/app/database-check.py /srv/config/database-check.py


#####
# Install nginx and setup configuration
#####

# Phusion: enable nginx
RUN rm -f /etc/service/nginx/down

# Add the nginx configuration file to the container
RUN rm /etc/nginx/sites-enabled/default
ADD ./config/nginx/nginx.j2 /srv/config/nginx/nginx.j2

# Copy SSL certs to location specified in nginx.conf
ADD ./config/nginx/localhost.crt /etc/ssl/certs/localhost.crt
ADD ./config/nginx/localhost.key /etc/ssl/private/localhost.key


#####
# Phusion: wsgi settings needed for passenger
#####
ADD ./config/app/passenger_wsgi.j2 /srv/config/app/passenger_wsgi.j2


#####
# Phusion: add additional script that need to run
#####
RUN mkdir -p /etc/m_init.d
ADD ./config/app/setup.sh /etc/my_init.d/setup.sh


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
# Phusion: Clean up APT when done.
#####
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
