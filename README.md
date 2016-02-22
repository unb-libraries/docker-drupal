# unblibraries/drupal:alpine-nginx-8.x [![](https://badge.imagelayers.io/unblibraries/drupal:alpine-nginx-8.x.svg)](https://imagelayers.io/?images=unblibraries/drupal:alpine-nginx-8.x 'Get your own badge on imagelayers.io') [![Build Status](https://travis-ci.org/unb-libraries/docker-drupal.svg?branch=alpine-nginx-8.x)](https://travis-ci.org/unb-libraries/docker-drupal)

A lightweight extensible Drupal docker image, suitable for a development-to-production workflow.

## Quick Start
This image does not contain a database (MySQL) server, although the [docker-compose.yml](https://github.com/unb-libraries/docker-drupal/blob/alpine-nginx-8.x/docker-compose.yml) file provided for convenience will deploy Drupal with a MySQL server with no additional configuration required. Looking for a really quick start?

```
git clone -b alpine-nginx-8.x git@github.com:unb-libraries/docker-drupal.git docker-drupal
cd docker-drupal
docker-compose up -d; docker-compose logs
```

And that's it! Don't have docker/docker-compose installed? See the [wiki pages](https://github.com/unb-libraries/docker-drupal/wiki/2.-Setting-Up-Prerequisites). New to Docker? Completely lost and not sure where to start? Check out the [unblibraries/drupal Wiki](https://github.com/unb-libraries/docker-drupal/wiki) for detailed instructions on deploying a local Drupal instance.

## Configuration Details
Several configurations are available, depending on your needs. Unless you have a particular reason to do so, it is suggested that you leverage the _:nginx-8.x_ base image, as it the most frequently used by the maintainer.


| Drupal Major   | apache/mod_php| nginx/php-fpm |
| ------------- | ------------- | ------------- |
|   |    |   |
| 7.x  | [unblibraries/drupal:alpine-apache-7.x](https://github.com/unb-libraries/docker-drupal/tree/alpine-apache-7.x)  | [unblibraries/drupal:alpine-nginx-7.x](https://github.com/unb-libraries/docker-drupal/tree/alpine-nginx-7.x)  |
| 8.x  | [unblibraries/drupal:alpine-apache-8.x](https://github.com/unb-libraries/docker-drupal/tree/alpine-apache-8.x)  | [unblibraries/drupal:alpine-nginx-8.x](https://github.com/unb-libraries/docker-drupal/tree/alpine-nginx-8.x)  |


## General Use
```
docker run \
       --rm \
       --name drupal \
       -e MYSQL_HOSTNAME= \
       -e MYSQL_PORT= \
       -e MYSQL_ROOT_PASSWORD= \
       -v /local/dir:/app/html \
       -p 80:80 \
       unblibraries/drupal:alpine-nginx-8.x
```

If ```MYSQL_HOSTNAME``` or ```MYSQL_PORT``` are unset, the container will attempt to determine these from a ```--link```ed MySQL container (specifically : environment variables ```MYSQL_PORT_3306_TCP_ADDR```, ```MYSQL_PORT_3306_TCP_ADDR```).

## Other Runtime/Environment Variables
Full documentation of environment variables is [available in the wiki](https://github.com/unb-libraries/docker-drupal/wiki/C.-Environment-Variables).

## License
- unblibraries/drupal is licensed under the MIT License:
  - [http://opensource.org/licenses/mit-license.html](http://opensource.org/licenses/mit-license.html)
- Attribution is not required, but much appreciated:
  - `Drupal Docker Image by UNB Libraries`
