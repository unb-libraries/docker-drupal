# unblibraries/drupal:alpine-nginx-7.x [![](https://badge.imagelayers.io/unblibraries/drupal:alpine-nginx-7.x.svg)](https://imagelayers.io/?images=unblibraries/drupal:alpine-nginx-7.x 'Get your own badge on imagelayers.io') [![Build Status](https://travis-ci.org/unb-libraries/docker-drupal.svg?branch=alpine-nginx-7.x)](https://travis-ci.org/unb-libraries/docker-drupal)
Simple, extensible Drupal docker image, suitable for local development and production.

The image serves content via nginx, and builds [Drupal](https://www.drupal.org/) 7.x using a [drush makefile](https://github.com/unb-libraries/docker-drupal/blob/alpine-nginx-7.x/build/unblibdef.yml) and performs a site-install using an [install profile](https://github.com/unb-libraries/docker-drupal/tree/alpine-nginx-7.x/build/unblibdef). Both of these can easily be overridden.

If a persistent filesystem is used and a previously deployed database is found, the image rebuilds the makefile and overwrites the current files using rsync. This makes it easy to perform upgrades and extend live instances.

This image does not contain a database (MySQL) server, although the [docker-compose.yml](https://github.com/unb-libraries/docker-drupal/blob/alpine-nginx-7.x/docker-compose.yml) file provided for convenience will deploy Drupal with a MySQL server with no configuration required, if you require a quick start.

## Other images
This branch is available on [dockerhub](https://hub.docker.com/r/unblibraries/drupal/) as `unblibraries/drupal:nginx-7.x`, and builds/serves Drupal 7.x via nginx. Other configurations are available:

|               | apache        | nginx         |
| ------------- | ------------- | ------------- |
| 7.x  | unblibraries/drupal:apache-7.x                                                                    | [unblibraries/drupal:nginx-7.x](https://github.com/unb-libraries/docker-drupal/tree/nginx-7.x)  |
| 8.x  | [unblibraries/drupal:apache-8.x](https://github.com/unb-libraries/docker-drupal/tree/apache-8.x)  | [unblibraries/drupal:nginx-8.x](https://github.com/unb-libraries/docker-drupal/tree/nginx-8.x)  |

## Getting Started
Not sure where to start? New to Docker? Check out the [unblibraries/drupal Wiki](https://github.com/unb-libraries/docker-drupal/wiki) for detailed instructions on deploying a local development instance. If are looking for something more production-ready, you probably don't need instructions. Just include this image in your Fleet unit file with the appropriate environment variables.

## Usage
```
docker run \
       --rm \
       --name drupal \
       -e MYSQL_HOSTNAME= \
       -e MYSQL_PORT= \
       -e MYSQL_ROOT_PASSWORD= \
       -v /local/dir:/app/html \
       -p 80:80 \
       unblibraries/drupal:alpine-nginx-7.x
```

## Runtime/Environment Variables

### Baseline Deployment
* `MYSQL_HOSTNAME` - (Required) The hostname of the MySQL server for the Drupal instance. This is not included in the image.
* `MYSQL_PORT` - (Required) The hostname of the MySQL server for the Drupal instance. This is not included in the image.

If a MySQL container is on the same docker host, uses port 3306 and is linked to the drupal container via ```--link``` , the above two environment variables do not need to be set.

* `MYSQL_ROOT_PASSWORD` - (Required) The root password for the MySQL server.
* `DRUPAL_DB_PASSWORD` - (Required) The password the drupal framework should assert to access the database.
* `DRUPAL_ADMIN_ACCOUNT_NAME` - (Optional) The admin account name. If not set, 'admin' will be used.
* `DRUPAL_ADMIN_ACCOUNT_PASS` - (Optional) The admin account password. If not set, 'admin' will be used.

### Overriding the Makefile and Install Profile
* `DRUPAL_SITE_ID` - (Optional) A unique string slug, (8 characters maximum) uniquely identifying the site install. This is only necessary if you have multiple installs from this image connecting to the same database host or wish to override the default makefile and install profile.

By passing `DRUPAL_SITE_ID` and ADDing :

* A makefile named `DRUPAL_SITE_ID.yml` to `$TMP_DRUPAL_BUILD_DIR/DRUPAL_SITE_ID.yml`
* A full install profile named `DRUPAL_SITE_ID` to `$TMP_DRUPAL_BUILD_DIR/DRUPAL_SITE_ID/`

The build process can be controlled to create any configuration desired.

### Cloning an Existing Instance
If key based access SSH is enabled on the server of an existing Drupal instance, the init process can clone that instance to the docker container. All of the following environment variables must be set, or the init script will not attempt to clone that instance. Please ensure that the makefile and profiles defined for the container match that of the existing instance, or erratic behavior will occur within the container.
* `DRUSH_TRANSFER_USER` - (Optional) The user account on the existing server.
* `DRUSH_TRANSFER_KEY` - (Optional) The contents of the private keyfile used to authenticate to the existing server.
* `DRUSH_TRANSFER_HOST` - (Optional) The hostname of the existing server.
* `DRUSH_TRANSFER_PATH` - (Optional) The path on the server to the existing Drupal installation.
* `DRUSH_TRANSFER_URI` - (Optional) The URI (usually 'default') of the existing instance.

## License
- unblibraries/drupal is licensed under the MIT License:
  - [http://opensource.org/licenses/mit-license.html](http://opensource.org/licenses/mit-license.html)
- Attribution is not required, but much appreciated:
  - `Drupal Docker Image by UNB Libraries`
