Docker Django
-------------

[![Circle CI](https://circleci.com/gh/erroneousboat/docker-django/tree/master.svg?style=shield)](https://circleci.com/gh/erroneousboat/docker-django/tree/master)

A project to get you started with Docker and Django. This is mainly made to
serve as an example for you to hack on. I don't claim that this is the
correct way to setup a system with Django and Docker, and if you have any
suggestions, please fork the project, send a pull-request or create an issue.
See the issues for the things I'm working on now.

This project uses [baseimage-docker](https://github.com/phusion/baseimage-docker) provided by [phusion](http://www.phusion.nl).

Stack that is being used: Docker, Docker Compose, Nginx, Django, uWSGI, Postgresql

The branch [passenger-docker](https://github.com/erroneousboat/docker-django/tree/passenger-docker) uses [Phusion passenger](https://www.phusionpassenger.com/) instead of uWSGI.

## Folder structure

```
$ tree -L 1 --dirsfirst
.
├── code                # main application code
├── config              # config files
├── utils               # useful scripts
├── circle.yml          # circle ci setup file
├── Dockerfile          # dockerfile for app container
├── docker-compose.yml  # docker-compose setup with container orchestration instructions
├── LICENSE             # license for this project
├── README.md           # this file
└── TODO.md             # issues currently worked on

```

## Setting up

### Docker
Install [docker](https://docker.io) for ubuntu:

```bash
$ curl -sSL https://get.docker.com/ubuntu/ | sudo sh
```

### Docker Compose (previously Fig)
Install [docker compose](https://github.com/docker/compose):

```bash
# Install with PyPi
$ pip install docker-compose

# or install via curl
curl -L https://github.com/docker/compose/releases/download/1.1.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose; chmod +x /usr/local/bin/docker-compose
```

Check the [github project](https://github.com/docker/docker-compose/releases) for new releases

### Django
Create django project in the `code` folder or copy a project to the `code`
folder or use the sample project enclosed in this project and go directly to
the section 'Fire it up':

```bash
$ django-admin.py startproject <name_project>
```

Edit `config/environment/env` file and add the name of your project at `DJANGO_PROJECT_NAME` or just leave it as is to start the default application.


Edit the `settings.py` file with the correct database credentials and static
root:

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': os.environ.get('POSTGRES_NAME'),
        'USER': os.environ.get('POSTGRES_USER'),
        'PASSWORD': os.environ.get('POSTGRES_PASSWORD'),
        'HOST': os.environ.get('POSTGRES_HOST'),
        'PORT': os.environ.get('POSTGRES_PORT'),
    }
}

STATIC_ROOT = '/srv/static-files'
```

### Phusion ssh (optional)
The phusion baseimage gives us the possibility to access the container through
ssh. Read their motives for this 
[here](https://github.com/phusion/baseimage-docker#login_ssh).

This project uses their `insecure_key` located in the `config/ssh/` folder to 
access the container. You can also add your own public key to this folder and 
use it to access the container. How to do this, read the section 
`Phusion: enable ssh access to container` in the `Dockerfile`.

### PostgreSQL
This repository uses the 
[erroneousboat/postgres](https://github.com/erroneousboat/postgres) image. 
This is a custom container also based off of Phusion's 
[baseimage-docker](https://github.com/phusion/baseimage-docker). If you
however want to use the official
[postgres](https://registry.hub.docker.com/_/postgres/) docker image. Then 
change the following line in the `docker-compose.yml` file.

```yaml
# Change this line ...
image: erroneousboat/postgres

# to ...
image: postgres
```

And set the name and user of the database in the `config/environment/env` file
to its default setting:

```
POSTGRES_NAME=postgres
POSTGRES_USER=postgres
```

### Environment variables
The file `config/environment/env` contains the environment variables needed in
the containers. You can edit this as you see fit, and at the moment these are
the defaults that this project uses. However when you intend to use this, keep
in mind that you should keep this file out of version control as it can hold
sensitive information regarding your project. The file itself will contain
some commentary on how a variable will be used in the container.

## Fire it up
Start the container by issuing one of the following commands:
```bash
$ docker-compose up             # run in foreground
$ docker-compose up -d          # run in background
```

## Other commands
Build images:
```bash
$ docker-compose build
$ docker-compose build --no-cache       # build without cache
```

See processes:
```bash
$ docker-compose ps                 # docker-compose processes
$ docker ps -a                      # docker processes (sometimes needed)
$ docker stats [container name]     # see live docker container metrics
```

Run commands in container:
```bash
# Name of service is the name you gave it in the docker-compose.yml
$ docker-compose run [service_name] /bin/bash
$ docker-compose run [service_name] python manage.py shell
$ docker-compose run [service_name] env                         # env vars
```

SSH into container (see also: Phusion ssh):
```bash
# Find app_name by using docker-compose ps
python utils/ssh.py [app_name] [optional_ssh_key]
```

Remove all docker containers:
```bash
docker rm $(docker ps -a -q)
```

Remove all docker images:
```bash
docker rmi $(docker images -q)
```

## Troubleshooting
I get the following error message when using the docker command:

```
FATA[0000] Get http:///var/run/docker.sock/v1.16/containers/json: dial unix /var/run/docker.sock: permission denied. Are you trying to connect to a TLS-enabled daemon without TLS? 

```

SOLUTION: Add yourself (user) to the docker group, remember to re-log after!

```bash
$ usermod -a -G docker <your_username>
$ service docker restart
```
