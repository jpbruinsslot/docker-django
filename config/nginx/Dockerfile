FROM nginx:latest

# Add the nginx configuration file to the container
RUN rm /etc/nginx/conf.d/default.conf
ADD nginx.tmpl /etc/nginx/conf.d/default.conf
ADD letsencrypt.conf /etc/nginx/snippets/letsencrypt.conf
ADD ssl.conf /etc/nginx/snippets/ssl.conf

RUN mkdir -p /srv/config

ADD start.sh /srv/config/start.sh
ADD reload.sh /srv/config/reload.sh
RUN chmod +x /srv/config/start.sh /srv/config/reload.sh

ENTRYPOINT ["/bin/bash", "/srv/config/start.sh"]
CMD ["nginx", "-g", "daemon off;"]