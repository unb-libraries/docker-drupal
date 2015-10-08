# unblibraries/drupal
Simple, extensible Drupal docker image, suitable for both development and production.

Serves content via [apache](https://github.com/unb-libraries/docker-drupal/tree/apache) or [nginx](https://github.com/unb-libraries/docker-drupal/tree/nginx).

The image builds [Drupal](https://www.drupal.org/) using a [drush makefile](https://github.com/unb-libraries/docker-drupal/blob/nginx/build/unblibdef.makefile) and performs a site-install using an [install profile](https://github.com/unb-libraries/docker-drupal/tree/nginx/build/unblibdef). Both of these can easily be overridden.

If a persistent filesystem is used and a previously deployed database is found, the image rebuilds the makefile and overwrites the current files using rsync. This makes it easy to perform upgrades and extend live instances.

This image does not contain a database (MySQL) server, although the docker-compose.yml file provided for convenience will deploy the default mysql image and attach to it with no configuration required.

Leverages the [phusion/baseimage](https://registry.hub.docker.com/u/phusion/baseimage/) my_init system.

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
       -v /local/dir:/usr/share/nginx \
       -p 80:80 \
       unblibraries/drupal
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

* A makefile named `DRUPAL_SITE_ID.makefile` to `$TMP_DRUPAL_BUILD_DIR/DRUPAL_SITE_ID.makefile`
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
