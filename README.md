# docker-server
docker proxy configurations for server

# Overview
Simple Docker setup for hosting multiple project on one server using docker. It uses [jwilder/nginx-proxy](https://github.com/jwilder/nginx-proxy) with [letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion) to proxy individual applications to subdomains. There are some basic Make command to generate new application directories.

# How it works
- The primary concept is only using docker images. There're plenty of options for bundling and distributing docker images now a days. one example if [GitHubs Package registry](https://help.github.com/en/articles/configuring-docker-for-use-with-github-package-registry). 
- Docker Compose allows use to load .env configurations. a big part of how this is set up is around managing configurations on .env and leaving the docker-compose for architectural definition.

# What's included

## Docker:

- Nginx proxy for subdomain with auto SSL
- Shared MySql container: to use in sub application, you must set the host to `mysql`. If. you change the name of the mysql service in docker-compose your sub application need to match that name
- mailhog server: Mailhog is a email service for capturing outgoing emails.

# Getting Started

- Clone the repo into your server
- Create a .env file and set env variables

```
cp .env.example .env
```
- Create and application (see below for `make new` command)
- Bring containers. up

```
make up
```


# Commands

## new

Crates new application directory:

| Argument          | Description                                                                                             |
|-------------------|---------------------------------------------------------------------------------------------------------|
| `APP_NAME`          | Name for directory and subdomain name                                                                   |
| `DOCKER_IMAGE_NAME` | docker image to pull, will need to run separate docker login command when pulling from private registry |

```
make new-application APP_NAME=[APP_NAME] IMAGE=[DOCKER_IMAGE_NAME]
```

## up

Bring `up` proxy application and sub applications all together

```
make up
```

## down

Bring `down` proxy application and sub applications all together

```
make down
```

#Roadmap

- [ ] Add automated way to log unto private registries via makefile