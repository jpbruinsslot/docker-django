# TODO

- [x] static files

- [x] optimize uwsgi

- [x] runit instead of supervisord?

- [x] Update passenger-docker branch to latest version

- [x] Testing and CI see: https://circleci.com/docs/docker

- [x] setup ssh for phusion

- [x] use docker-compose instead of fig

- [x] Customizing Postgres in Docker, [link](https://osxdominion.wordpress.com/2015/01/25/customizing-postgres-in-docker/)

- [x] docker-compose.yml now has an env_file key, analogous to docker run --env-file, letting you specify multiple environment variables in a separate file. This is great if you have a lot of them, or if you want to keep sensitive information out of version control.

- [x] Check in setup.sh if the database container is ready to accept connections
and then execute the django setup 

- [ ] Check if it is possible to use the official postgres image and if the
project will still run

- [ ] Add commentary to the variables on how they are used

- [ ] "We encourage you to use multiple processes." from [phusion](http://phusion.github.io/baseimage-docker/), does this also mean postgres in the same container?

- [ ] Deployment to production servers
