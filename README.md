# unblibraries/drupal [![](https://images.microbadger.com/badges/image/unblibraries/drupal:alpine-nginx-php7-8.x.svg)](http://microbadger.com/images/unblibraries/drupal:alpine-nginx-php7-8.x "Get your own image badge on microbadger.com") [![Build Status](https://travis-ci.org/unb-libraries/docker-drupal.svg?branch=alpine-nginx-php7-8.x)](https://travis-ci.org/unb-libraries/docker-drupal)

A lightweight extensible Drupal docker image, suitable for a development-to-production workflow.

## Quick Start
This image does not contain a database (MySQL) server, although the [docker-compose.yml](https://github.com/unb-libraries/docker-drupal/blob/alpine-nginx-php7-8.x/docker-compose.yml) file provided for convenience will deploy Drupal with a MySQL server with no additional configuration required. Looking for a really quick start?

```
git clone -b alpine-nginx-php7-8.x git@github.com:unb-libraries/docker-drupal.git docker-drupal
cd docker-drupal
docker-compose up -d; docker-compose logs
```

And that's it! Don't have docker/docker-compose installed? See the [wiki pages](https://github.com/unb-libraries/docker-drupal/wiki/2.-Setting-Up-Prerequisites). New to Docker? Completely lost and not sure where to start? Check out the [unblibraries/drupal Wiki](https://github.com/unb-libraries/docker-drupal/wiki) for detailed instructions on deploying a local Drupal instance.

## Repository Tags
This image was previously available in many configurations and formats, which became a tremendous maintenance burden. As of June 17 2016, there is currently only one supported branch. The other branches have been deprecated and will not be updated. They will most likely become broken! If you wish to contribute to the project and maintain these other configurations, please contact us.


|                    Tag                    | Drupal | PHP   | Size                                                                                                                                                                                               | Status                                                                                                                                                    |
|:-----------------------------------------:|--------|-------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| unblibraries/drupal:alpine-nginx-php7-8.x |   8.x  | 7.0.x | [![](https://images.microbadger.com/badges/image/unblibraries/drupal:alpine-nginx-php7-8.x.svg)](http://microbadger.com/images/unblibraries/drupal:alpine-nginx-php7-8.x "Get your own image badge on microbadger.com") | [![Build Status](https://travis-ci.org/unb-libraries/docker-drupal.svg?branch=alpine-nginx-php7-8.x)](https://travis-ci.org/unb-libraries/docker-drupal) |


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
       unblibraries/drupal:alpine-nginx-php7-8.x
```

## Other Runtime/Environment Variables
Full documentation of environment variables is [available in the wiki](https://github.com/unb-libraries/docker-drupal/wiki/C.-Environment-Variables).

## License
- unblibraries/drupal is licensed under the MIT License:
  - [http://opensource.org/licenses/mit-license.html](http://opensource.org/licenses/mit-license.html)
- Attribution is not required, but much appreciated:
  - `Drupal Docker Image by UNB Libraries`
