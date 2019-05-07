# unblibraries/drupal [![](https://images.microbadger.com/badges/image/unblibraries/drupal:8.x-1.x.svg)](http://microbadger.com/images/unblibraries/drupal:8.x-1.x "Get your own image badge on microbadger.com") [![Build Status](https://travis-ci.org/unb-libraries/docker-drupal.svg?branch=8.x-1.x)](https://travis-ci.org/unb-libraries/docker-drupal)

A lightweight extensible Drupal docker image, suitable for a development-to-production workflow.

## Quick Start
This image does not contain a database (MySQL) server, although the [docker-compose.yml](https://github.com/unb-libraries/docker-drupal/blob/8.x-1.x/docker-compose.yml) file provided for convenience will deploy Drupal with a MySQL server with no additional configuration required. Looking for a really quick start?

```
git clone -b 8.x-1.x git@github.com:unb-libraries/docker-drupal.git docker-drupal
cd docker-drupal
docker-compose up -d; docker-compose logs
```

## How To Use
This image offers little benefit on its own, and shines when serving as the base of an extension. [An example of how we extend this image for a production site](https://github.com/unb-libraries/newspapers.lib.unb.ca) should provide enough for you to get started.

## Repository Tags
This image was previously available in many configurations and formats, which became a tremendous maintenance burden.There is currently only one supported branch - Drupal 8 and PHP7 built by Composer.

The other branches have been deprecated and will not be updated. They will most likely become broken! If you wish to contribute to the project and maintain these other configurations, please contact us.


|                    Tag                    | Drupal | PHP   | Size                                                                                                                                                                                               | Status                                                                                                                                                    |
|:-----------------------------------------:|--------|-------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------|
| unblibraries/drupal:8.x-1.x |   8.x  | 7.2.x | [![](https://images.microbadger.com/badges/image/unblibraries/drupal:8.x-1.x.svg)](http://microbadger.com/images/unblibraries/drupal:8.x-1.x "Get your own image badge on microbadger.com") | [![Build Status](https://travis-ci.org/unb-libraries/docker-drupal.svg?branch=8.x-1.x)](https://travis-ci.org/unb-libraries/docker-drupal) |


## Other Runtime/Environment Variables
Full documentation of environment variables is [available in the wiki](https://github.com/unb-libraries/docker-drupal/wiki/C.-Environment-Variables).

## License
- unblibraries/drupal is licensed under the MIT License:
  - [http://opensource.org/licenses/mit-license.html](http://opensource.org/licenses/mit-license.html)
- Attribution is not required, but much appreciated:
  - `Drupal Docker Image by UNB Libraries`
