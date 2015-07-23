# unblibraries/drupal
Simple, extensible Drupal docker container. Leverages the phusion/baseimage my_init system.

Builds and installs from scratch if a database and filesystem is not found. Updates from makefile if database and filesystem exist.

## Usage
```
docker run \
       --rm \
       --name drupal \
       -e MYSQL_HOSTNAME= \
       -e MYSQL_ROOT_PASSWORD= \
       -v /local/dir:/usr/share/nginx \
       -p 80:80 \
       unblibraries/drupal
```

## License
- unblibraries/drupal is licensed under the MIT License:
  - http://opensource.org/licenses/mit-license.html
- Attribution is not required, but much appreciated:
  - `Drupal Docker Container by UNB Libraries`
