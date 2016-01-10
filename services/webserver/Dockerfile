FROM nginx:1.9.6

# Add start script
ADD ./services/webserver/config/start.sh /
RUN chmod +x start.sh

# Add template application
ADD ./config/utils/template/template /usr/local/bin/template
RUN chmod +x /usr/local/bin/template

# Add nginx config file
ADD ./services/webserver/config/nginx.tmpl /

# Add SSL certs to location specified in nginx.conf
ADD ./services/webserver/config/*.crt /etc/ssl/certs/
ADD ./services/webserver/config/*.key /etc/ssl/private/

# Execute start script
CMD ["./start.sh"]
