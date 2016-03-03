# Extending unblibraries/drupal
The unblibraries/drupal base image has limited use on its own. It is more likely that you would want to use the image as the basis for creating a custom Drupal site. To create a new, configurable image to serve as the foundation of your development, follow these steps. __Note : Steps 1 and 2 are for OSX Only. If you are deploying on Linux you can [install docker](https://docs.docker.com/engine/installation/), and skip directly to step 3__.

> Heads Up : sudo is used for some of these steps. If a password prompt appears, it will be to prompt for your local root account password to escalate privileges.

### 1. Ensure Dependencies are installed

1. Download the Installer from the [Docker Toolbox](https://www.docker.com/toolbox) site.
2. If you already have Virtualbox installed, halt any virtual machines that are running.
3. Open the installer. Install using the default options, but **do not choose a default tool when asked at the end of the installation process. Simply click 'continue', then exit**.

### 2. Deploy a new docker-machine VM
Provision the VM:

```
> docker-machine create --driver virtualbox docker-machine-drupal
```

Apply the [VBOXSF/NFS fix](http://jacobsanford.com/blog/2016/02/18/solultion-boot2docker-issue-number-581/):

```
> curl -s https://raw.githubusercontent.com/adlogix/docker-machine-nfs/master/docker-machine-nfs.sh |
  sudo tee /usr/local/bin/docker-machine-nfs > /dev/null && \
  sudo chmod +x /usr/local/bin/docker-machine-nfs
> docker-machine-nfs docker-machine-drupal --nfs-config="-maproot=0"
```

Set up the host machine docker environment variables:

```
> docker-machine env docker-machine-drupal
set -gx DOCKER_TLS_VERIFY "1";
set -gx DOCKER_HOST "tcp://192.168.99.100:2376";
set -gx DOCKER_CERT_PATH "/Users/jsanford/.docker/machine/machines/docker-machine-drupal";
set -gx DOCKER_MACHINE_NAME "docker-machine-drupal";
# Run this command to configure your shell:
# eval (docker-machine env docker-machine-drupal)

> eval (docker-machine env docker-machine-drupal)
```

### 3. Generate extension of unblibraries/drupal
Clone this project and run _extendImage.sh_.

```
> git clone -b alpine-nginx-8.x git@github.com:unb-libraries/docker-drupal.git
> cd docker-drupal/extend
> ./extendImage.sh
```

### 4. Launch your new container
Following instructions given to you by _extendImage.sh_:
```
> cd /Users/jsanford/docker-drupal-fansite
```

This is the tree where you may configure your new image. Check it out! Within it is a configurable makefile, install profile, settings overrides and scripts to run on deploy. When you are ready to launch your image:

```
> ./deploy.sh
```

## Common Errors And Solutions

#### Port Collision From Other Images

```Error: Cannot start container X: port has already been allocated```

This indicates that the default port (8080) mapped the host port specified in _docker-compose.yml_ Change it to another value:

```
ports:
  - "8083:80"
```

 and re-run _deploy.sh_.

#### Orphaned NFS Exports

When running ```docker-machine-nfs``` :

```exports:3: export option conflict for /Users```

This indicates a previous instance using docker-machine-nfs was not correctly cleaned up. Edit the exports file and remove any lines referencing /User that you are not currently using:

```sudo nano /etc/exports```
