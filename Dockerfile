#####
# Using docker image by phusion see: http://phusion.github.io/baseimage-docker/
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
    build-essential \
    libpq-dev \
    postgresql \
    git-core \
    curl \
    tmux \
    vim \
    wget \
    nodejs \
    python \
    python-dev \
    python-setuptools \
    nginx \
    supervisor


#####
# Install and setup  PIP, uWSGI and virtualenv.
#####

# Install pip
RUN easy_install pip

# Install application requirements
ADD ./config/app/requirements.txt /srv/config/requirements.txt
RUN pip install -r /srv/config/requirements.txt


#####
# Install nginx and setup configuration
#####

# daemon mode off, we will run this with supervisor
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Add the nginx configuration file to the container
RUN rm /etc/nginx/sites-enabled/default
ADD ./config/nginx/nginx.j2 /srv/config/nginx/nginx.j2

# Copy SSL certs to location specified in nginx.conf
ADD ./config/nginx/localhost.crt /etc/ssl/certs/localhost.crt
ADD ./config/nginx/localhost.key /etc/ssl/private/localhost.key


#####
# Create django user, will own the Django app
#####
RUN adduser --no-create-home --disabled-login --group --system django
RUN chown -R django:django /srv/django


#####
# Setup supervisor
#####
ADD ./config/app/supervisor-app.conf /etc/supervisor/conf.d/supervisor-app.conf


#####
# Add uWSGI config
#####
ADD ./config/app/django-uwsgi.ini /etc/uwsgi/django-uwsgi.ini


#####
# Phusion: Clean up APT when done.
#####
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


#####
# Add entrypoint script and go!
#####
ADD ./config/app/run.sh /run.sh
CMD ["/run.sh"]