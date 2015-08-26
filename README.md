# unblibraries/drupal
Simple, extensible Drupal docker container. Leverages the [phusion/baseimage](https://registry.hub.docker.com/u/phusion/baseimage/) my_init system.

This image does not contain a Database (MySQL) server, although the docker-compose.yml file provided for convenience will build and attach one for you.

It builds and installs [Drupal](https://www.drupal.org/) using the embedded makefile and install profile from scratch (if a database and filesystem is not found). Content is served via [apache](http://httpd.apache.org/).

If a persistent filesystem is used and a previous build and database is found, the image defined makefile is built and applied to the current instance, overwriting the existing filesystem.

This upgrade system allows in-place upgrades only by updating the makefile, and is appropriate for Github post-commit hook driven rebuilds.

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

### Overriding the Makefile and Install Profile
* `DRUPAL_SITE_ID` - (Optional) A unique string slug, (8 characters maximum) uniquely identifying the site install. This is only necessary if you have multiple installs from this image to the same database or wish to override the default makefile and install profile.

By passing `DRUPAL_SITE_ID` and ADDing :

* A makefile named `DRUPAL_SITE_ID.makefile` to `/tmp/drupal_build/DRUPAL_SITE_ID.makefile`
* A full install profile named `DRUPAL_SITE_ID` to  `/tmp/drupal_build/DRUPAL_SITE_ID/`

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
  - `Drupal Docker Container by UNB Libraries`
