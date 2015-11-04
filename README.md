Docker Django
-------------

[![Circle CI](https://circleci.com/gh/niieani/docker-django.svg?style=shield)](https://circleci.com/gh/niieani/docker-django)

A project to get you started with Docker and Django. This is mainly made to
serve as an example for you to hack on. I don't claim that this is the
correct way to setup a system with Django and Docker, and if you have any
suggestions, please fork the project, send a pull-request or create an issue.
See the issues for the things I'm working on now.

Stack that is being used: Docker, Docker Compose, Nginx, Django, uWSGI, Postgresql

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
└── README.md           # this file

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
curl -L https://github.com/docker/compose/releases/download/1.5.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose; chmod +x /usr/local/bin/docker-compose
```

Check the [github project](https://github.com/docker/docker-compose/releases) for new releases

### Django

First, copy your django project to the `projects` folder or create a fresh one,
or use the sample project enclosed in this project.

Since this project makes use of the docker-compose yml overrides to build up your instance, you'll need to create a.


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

STATIC_ROOT = '/srv/static'
```

### Environment variables
The file `config/env` contains the environment variables needed in
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

Take note that this will spin up entirely new containers for your code
but only if the containers are not up already, in which case they are linked
to that (running) container. To initiate a command in an existing running
container you'll have two methods, either by using the `docker exec` tool
or through ssh.

Remove all docker containers:
```bash
docker rm $(docker ps -a -q)
```

Remove all docker images:
```bash
docker rmi $(docker images -q)
```

## Troubleshooting
QUESTION: I get the following error message when using the docker command:

```
FATA[0000] Get http:///var/run/docker.sock/v1.16/containers/json: dial unix /var/run/docker.sock: permission denied. Are you trying to connect to a TLS-enabled daemon without TLS? 

```

SOLUTION: Add yourself (user) to the docker group, remember to re-log after!

```bash
$ usermod -a -G docker <your_username>
$ service docker restart
```

QUESTION: Changes in my code are not being updated despite using volumes.

SOLUTION: Remember to restart uWSGI for the changes to take effect.
