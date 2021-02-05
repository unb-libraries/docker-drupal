# unb-libraries/docker-drupal

A lightweight extensible Drupal docker image, suitable for a development-to-production workflow.

## How To Use
This image offers little benefit on its own, and shines when serving as the base of an extension. [An example of how we extend this image for our main library site](https://github.com/unb-libraries/lib.unb.ca) should provide enough for you to get started.

## Repository Tags
This image was previously available in many configurations and formats, which became a tremendous maintenance burden. There is currently only one supported branch - Drupal 8 and PHP7 built by Composer.

The other branches have been deprecated and will not be updated. They will most likely become broken! If you wish to contribute to the project and maintain these other configurations, please contact us.


|                    Tag                    | Drupal | PHP   |
|:-----------------------------------------:|--------|-------|
| ghcr.io/unb-libraries/drupal:8.x-3.x |   8.x  | 7.3.x |

## Licensing
- As part of our 'open' ethos, UNB Libraries licenses its applications and workflows to be freely available to all whenever possible.
- Consequently, the contents of this repository [unb-libraries/docker-drupal] are licensed under the [MIT License](http://opensource.org/licenses/mit-license.html). This license explicitly excludes:
   - Any website content, which remains the exclusive property of its author(s).
   - The UNB logo and any of the associated suite of visual identity assets, which remains the exclusive property of the University of New Brunswick.
