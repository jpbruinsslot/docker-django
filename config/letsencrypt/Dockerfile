FROM quay.io/letsencrypt/letsencrypt:latest

ADD letsencrypt-unprivileged.sh /opt/letsencrypt/

ENTRYPOINT [ "bash", "/opt/letsencrypt/letsencrypt-unprivileged.sh" ]