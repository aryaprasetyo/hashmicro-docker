# Prerequisite

- docker
- docker-compose
- portainer (optional)
- docker desktop (optional)
# Usage

Change the folder permission to make sure that the container is able to access the directory:
```
$ sudo chmod -R 777 etc
```

# HM2 addons
clone ur repo into `addons` folder

change `<REPO_NAME>` in `yml` file with ur repo name

then 
```
$ docker-compose up -d --build
```

go to ur odoo container then access the container`s terminal

then execute
```
cp -R /mnt/hm-addons/basic/* /opt/odoo/addons
```

command code in path 
```
/root/.local/lib/python3.8/site-packages/frontend/server.py 
or
/usr/local/lib/python3.8/dist-packages/frontend/server.py
```
if server error in this module
```
app.mount(config.STATIC_ROUTE, StaticFiles(directory=config.STATIC_DIRECTORY), name=config.STATIC_NAME)

```


# Odoo configuration

To change Odoo configuration, edit file: **etc/odoo.conf**.

