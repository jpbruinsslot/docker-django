Docker Django Starter
---------------------

A project to get you started with Docker and Django. This is mainly made to
serve as an example for you to hack on. I don't claim that this is the
correct way to setup a system with Django and Docker, and if you have any
suggestions, please fork the project, send a pull-request or create an issue.
See `TODO.md` for issues that I'm currently working on.

Stack that is being used: Docker, Fig, Nginx, Django, uWSGI, Postgresql

## Folder structure

```
$ tree -L 1 --dirsfirst
.
├── code            # main application code
├── config          # config files
├── static-files    # static files to be served with nginx
├── Dockerfile      # dockerfile for app container
├── fig.yml         # fig setup with container orchestration instructions
└── README.md       # this file
└── TODO.md         # issues currently worked on

```

## Setting up
Install [docker](https://docker.io) for ubuntu:

```bash
$ curl -sSL https://get.docker.com/ubuntu/ | sudo sh
```

Install [fig](http://fig.sh):

```bash
$ sudo pip install fig
```

Create django project in the `code` folder or copy a project to the `code`
folder:

```bash
$ django-admin.py startproject <name_project>
```

Edit `fig.yml` file and add the name of your project at `DJ_PROJECT_NAME`

Edit the `settings.py` file with the correct database credentials:

```
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': os.environ.get('DB_NAME'),
        'USER': os.environ.get('DB_USER'),
        'PASSWORD': os.environ.get('DB_PASS'),
        'HOST': os.environ.get('DB_HOST'),
        'PORT': os.environ.get('DB_PORT'),
    }
}
```

## Fire it up
Start the container by issuing one of the following commands:

```bash
$ sudo fig up             # run in foreground
$ sudo fig up -d          # run in background
```

## Other commands
Build images:

```bash
$ sudo fig build
$ sudo fig build --no-cache       # build without cache
```

See processes

```bash
$ sudo fig ps             # fig processes
$ sudo docker ps -a       # docker processes (sometimes needed)
```

Run commands in container

```bash
$ sudo fig run <service_name> /bin/bash
$ sudo fig run <service_name> python manage.py shell
$ sudo fig run <service_name> env                         # env vars
```

Name of service is the name you gave it in the fig.yml

## Troubleshooting
I get the following error message when using the docker command:

```
FATA[0000] Get http:///var/run/docker.sock/v1.16/containers/json: dial unix /var/run/docker.sock: permission denied. Are you trying to connect to a TLS-enabled daemon without TLS? 

```

SOLUTION: Add yourself (user) to the docker group, remember to re-log after!

```bash
$ sudo usermod -a -G docker <your_username>
$ sudo service docker restart
```
