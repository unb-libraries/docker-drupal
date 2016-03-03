# Extending This Image
The base image has limited use on it's own. To leverage this image as a base image for your development:

## OSX
sudo is necessary (only during initial setup )for some of these steps. If a password prompt appears, it will be to prompt for your local OSX account password to escalate privileges.

```
> docker-machine create --driver virtualbox docker-machine-drupal
> curl -s https://raw.githubusercontent.com/adlogix/docker-machine-nfs/master/docker-machine-nfs.sh |
  sudo tee /usr/local/bin/docker-machine-nfs > /dev/null && \
  sudo chmod +x /usr/local/bin/docker-machine-nfs
> docker-machine-nfs docker-machine-drupal --nfs-config="-maproot=0"
> docker-machine env docker-machine-drupal
> git clone -b alpine-nginx-8.x git@github.com:unb-libraries/docker-drupal.git
> cd docker-drupal/extend
> ./extendImage.sh
```

## Common Errors And Solutions

### Port Collision From Other Images:

```Error: Cannot start container X: port has already been allocated```

This indicates that you have already mapped the host port specified in docker-compose.yml. Change it to something new and re-run ./deploy.sh:

```
ports:
  - "8083:80"
```

### Orphaned NFS Exports

When running ```docker-machine-nfs``` :

```exports:3: export option conflict for /Users```

This indicates a previous instance using docker-machine-nfs was not correctly tidied up. Edit the exports file and remove any old references:

```sudo nano /etc/exports```
