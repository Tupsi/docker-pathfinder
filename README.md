### docker-pathfinder

**docker-pathfinder** is a docker-compose setup that contains a hassle free out of the box setup for [Pathfinder](https://developers.eveonline.com/https://github.com/exodus4d/pathfinder).

**Features**
* Setup Scripts for most initial stuff
* Password Protection of the setup page
* Socket Server running out of the box
* Redis 6.0.9
* php 7.4
* nginx 1.18
* Automatic Restart in-case of crash
* Traefik labels for easy Reverse-Proxy usage out of the box

### How to run it

**Prerequisites**:
* [docker](https://docs.docker.com/)
* [docker-compose](https://docs.docker.com/)
* A Reverse-Proxy sitting infront of this for forwarding everything to port 80.

1. **Create an [API-Key](https://developers.eveonline.com/) with the scopes listed in the [wiki](https://github.com/exodus4d/pathfinder/wiki/SSO-ESI)** 

2. **Clone the repo**
```shell
git clone --recurse-submodules  https://github.com/Tupsi/docker-pathfinder.git
```

3. **Copy .env_sample to .env and fill out**
```shell
# Rename this file to .env
path="." #works as long as you start docker-compose from this directory. Otherwise put in your absolute path.
CONTAINER_NAME="pf"
DOMAIN="<put your domain in here>" #the FQDN you want to access pathfinder
SERVER_NAME="PATHFINDER"
SETUP_USER="<user for the setup page>" #user for the setup page
SETUP_PASSWORD="<password for the setup page>" # password for the setup page
MYSQL_PASSWORD="<random mysql password>" # password for the database
# Get your API Key from https://developers.eveonline.com/applications
# Do NOT forget to put the correct Callback URL in (https://<yourdomain>/sso/callbackAuthorization)
CCP_SSO_CLIENT_ID=""
CCP_SSO_SECRET_KEY=""
CCP_ESI_SCOPES="esi-location.read_online.v1,esi-location.read_location.v1,esi-location.read_ship_type.v1,esi-ui.write_waypoint.v1,esi-ui.open_window.v1,esi-universe.read_structures.v1,esi-corporations.read_corporation_membership.v1,esi-clones.read_clones.v1"
```
4. **(Optional) Check Traefik labels. **
If you are using traefik, check entrypoints (http, https), docker.network (proxy) and certresolver (http) with your setup.

5. **(Optional) Finetune redis, nginx, php. **
The config files used in the build process are located in the /static folder. So if you wanna tweak something, do it in there before you go to the next step, as these get pulled into the image and if you change it later, you have todo another build run.

6. **Build and Run it**
```shell                                                                                        
docker-compose build && docker-compose up -d
```

7. **Create Datebases. **
Open the https://< your-domain >/setup page. Your username  and password from .env. Click on create database for eve_universe and pathfinder. And click on setup tables && fix column/keys for both databases.

8. **Import Eve-Universe Database**
```shell                                                                                        
./installEveUniverseDB.sh
```
9. **(Optional) If you want to finetune settings**
```shell                                                                                        
./getConfigs.sh
```
You can now change/add settings inside /conf and these will override what is in /app.

10. **That's it! Enjoy your Pathfinder docker stack!**

### Tweaking

If you want to change settings inside the image at a later point in time, simply edit the files in /static and run
```shell                                                                                        
docker-compose build --no-cache && docker-compose up -d
```
afterwards.
I exposed the /backup path as volume, so I can backup my sql dump from inside. If you want to do that as well, run the following outside prior to your backup run.
```shell                                                                                        
docker exec pf-db sh -c "mysqldump -u root -p<your db password from .env> --add-drop-database --databases pf >/backup/pathfinder.sql"
```                                                                                     

### Acknowledgments
*  [exodus4d](https://github.com/exodus4d/) for pathfinder
*  techfreak for initial pointers from his [version](https://gitlab.com/techfreak/pathfinder-container)
*  People from the Pathfinder Slack community for helping out

### Authors
* tupsi

### License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

