Docker Django
-------------

[![Circle CI](https://circleci.com/gh/niieani/docker-django.svg?style=shield)](https://circleci.com/gh/niieani/docker-django)

A production-quality, hackable project to get you started with Docker and Django. 
I don't claim that this is the correct way to setup a system with Django and Docker, 
and if you have any suggestions, please fork the project, send a pull-request or create an issue.
See the issues for the things I'm working on now.

Stack that is being used: Docker, Docker Compose, Nginx, Django, uWSGI, Postgresql, LetsEncrypt

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

Create a pip.txt file inside of your project main folder and specify the requirements of your project.
See `starter` for an example.

Edit the `settings.py` file with the correct database credentials and static root:

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

### Creating a project

Once you've put your Django project into the `projects` folder, invoke:
```bash
$ ./create PROJECT_NAME
```

This will start a small script which will guide you in creating an override file that's required to build your new project.

### Environment variables and settings
Once it's created, you may modify available variables inside of your new `docker-compose.PROJECT.yml` override file.

## Fire it up
Start the container by issuing one of the following commands:
```bash
$ ./compose PROJECT_NAME up             # run in foreground
$ ./compose PROJECT_NAME up -d          # run in background
```

## Other commands
Build images:
```bash
$ ./compose PROJECT_NAME build
$ ./compose PROJECT_NAME build --no-cache       # build without cache
```

See processes:
```bash
$ ./compose PROJECT_NAME ps         # docker-compose processes
$ ./compose PROJECT_NAME logs       # watch logs
$ docker ps -a                      # docker processes (sometimes needed)
$ docker stats [container name]     # see live docker container metrics
```

Run commands in the existing Django container:

```bash
# A special alias will let you enter Django manage commands:
$ ./compose $PROJECT manage ...

# You can also reload Django and Nginx with:
$ ./compose $PROJECT reload

# Enter bash in the Django container:
$ ./compose $PROJECT bash
```

Run commands in new containers of other services:
```bash
# Name of service is the name from docker-compose*.yml
$ docker-compose run [service_name] /bin/bash
$ docker-compose run [service_name] env                         # env vars
```

Take note these last 2 commands will spin up entirely new containers for your code
but only if the containers are not up already, in which case they are linked
to that (running) container. To initiate a command in existing running
container (other than `app`) you'll need to do it manually by using the `docker exec` tool.

Remove all docker containers (use with care!):
```bash
docker rm $(docker ps -a -q)
```

Remove all docker images:
```bash
docker rmi $(docker images -q)
``` 

## Hackability
Each `docker-compose.PROJECT_NAME.yml` is an override file that defines your own project, meaning anything you put there merely adds on top of what's in `docker-compose.yml`.

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
