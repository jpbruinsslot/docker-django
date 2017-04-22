FROM python:3.6

# Add code
ADD ./starter /srv/starter

# Install application requirements
ADD ./config/requirements.txt /srv/starter/
RUN pip3 install -r /srv/starter/requirements.txt

# Add start script
ADD ./config/start.sh /

# Add uWSGI config
ADD ./config/django-uwsgi.ini /etc/uwsgi/django-uwsgi.ini

# Add database check script
ADD ./config/database-check.py /srv/config/database-check.py

# Create django user, will own the Django app
RUN adduser --no-create-home --disabled-login --group --system django
RUN chown -R django:django /srv/starter

# Execute start script
CMD ["./start.sh"]
