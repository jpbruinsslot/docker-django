FROM nginx:latest

# Add the nginx configuration file to the container
RUN rm /etc/nginx/conf.d/default.conf
ADD nginx.tmpl /etc/nginx/conf.d/default.conf

ADD start.sh /srv/start.sh
RUN chmod +x /srv/start.sh

ENTRYPOINT ["/bin/bash", "/srv/start.sh"]
CMD ["nginx", "-g", "daemon off;"]