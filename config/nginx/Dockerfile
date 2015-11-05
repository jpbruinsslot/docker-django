FROM nginx:latest

# Add the nginx configuration file to the container
RUN rm /etc/nginx/conf.d/default.conf
ADD nginx.tmpl /etc/nginx/conf.d/default.conf
ADD letsencrypt.conf /etc/nginx/snippets/letsencrypt.conf
ADD ssl.conf /etc/nginx/snippets/ssl.conf

ADD default.crt /srv/config/fullchain.pem
ADD default.key /srv/config/privkey.pem
ADD default.key /srv/config/dhparam.pem

RUN mkdir -p /srv/config

ADD start.sh /srv/config/start.sh
ADD reload.sh /srv/config/reload.sh
RUN chmod +x /srv/config/start.sh /srv/config/reload.sh

ENTRYPOINT ["/bin/bash", "/srv/config/start.sh"]
CMD ["nginx", "-g", "daemon off;"]