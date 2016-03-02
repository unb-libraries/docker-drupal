# Extending This Image
The base image has limited use on it's own. To leverage this image as a base image for your development:

## OSX
sudo is necessary (only during initial setup )for some of these steps. If a password prompt appears, it will be to prompt for your local OSX account password to escalate privileges.

```
> docker-machine create --driver virtualbox docker-machine-drupal
> curl -s https://raw.githubusercontent.com/adlogix/docker-machine-nfs/master/docker-machine-nfs.sh |
  sudo tee /usr/local/bin/docker-machine-nfs > /dev/null && \
  sudo chmod +x /usr/local/bin/docker-machine-nfs
> docker-machine-nfs docker-machine-drupal
> git clone -b alpine-nginx-7.x git@github.com:unb-libraries/docker-drupal.git
> cd docker-drupal/extend
> ./extendImage.sh
```
