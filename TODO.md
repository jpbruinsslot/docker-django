# TODO

- [x] static files

- [x] optimize uwsgi

- [x] runit instead of supervisord?

- [x] Update passenger-docker branch to latest version

- [x] Testing and CI see: https://circleci.com/docs/docker

- [x] setup ssh for phusion

- [x] use docker-compose instead of fig

- [ ] "We encourage you to use multiple processes." from [phusion](http://phusion.github.io/baseimage-docker/), does this also mean postgres in the same container?

- [ ] Customizing Postgres in Docker, [link](https://osxdominion.wordpress.com/2015/01/25/customizing-postgres-in-docker/)

- [ ] Deployment to production servers

- [ ] docker-compose.yml now has an env_file key, analogous to docker run --env-file, letting you specify multiple environment variables in a separate file. This is great if you have a lot of them, or if you want to keep sensitive information out of version control.