# unb-libraries/docker-drupal  [![](https://github.com/unb-libraries/docker-drupal/workflows/build-test-deploy/badge.svg?branch=`9.x-1.x`)](https://github.com/unb-libraries/docker-drupal/actions?query=workflow%3Abuild-test-deploy) [![GitHub license](https://img.shields.io/github/license/unb-libraries/docker-drupal)](https://github.com/unb-libraries/lib.unb.ca/blob/prod/LICENSE) ![GitHub repo size](https://img.shields.io/github/repo-size/unb-libraries/docker-drupal?label=lean%20repo%20size)
A lightweight, extensible Drupal docker image, suitable for a development-to-production workflow.

## Usage
This image offers little benefit on its own, but shines when serving as a base image for an application. An example of how we extend this image for [https://lib.unb.ca](https://lib.unb.ca) should provide a reference for you to get started.

## Branches/Tags
The only currently maintained image/tag is **ghcr.io/unb-libraries/drupal:10.x-1.x**. Previous branches are not under active development, and are only maintained for legacy reasons.

|                 Tag                  | Drupal | PHP   |
|:------------------------------------:|--------|-------|
| ghcr.io/unb-libraries/drupal:10.x-1.x |   10.x  | 8.1.x |
| ghcr.io/unb-libraries/drupal:9.x-2.x |   9.x  | 7.4.x |
| ghcr.io/unb-libraries/drupal:8.x-3.x |   8.x  | 7.4.x |


## Author / Contributors
This application was created at [![UNB Libraries](https://github.com/unb-libraries/assets/raw/master/unblibbadge.png "UNB Libraries")](https://lib.unb.ca) by the following humans:

<a href="https://github.com/JacobSanford"><img src="https://avatars.githubusercontent.com/u/244894?v=3" title="Jacob Sanford" width="128" height="128"></a>
<a href="https://github.com/bricas"><img src="https://avatars.githubusercontent.com/u/18400?v=3" title="Brian Cassidy" width="128" height="128"></a>

## License
- As part of our 'open' ethos, UNB Libraries licenses its applications and workflows to be freely available to all whenever possible.
- Consequently, the contents of this repository [unb-libraries/docker-drupal] are licensed under the [MIT License](http://opensource.org/licenses/mit-license.html). This license explicitly excludes:
  - Any website content, which remains the exclusive property of its author(s).
  - The UNB logo and any of the associated suite of visual identity assets, which remains the exclusive property of the University of New Brunswick.
