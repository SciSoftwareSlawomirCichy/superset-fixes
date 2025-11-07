#!/bin/bash
######################################################################
# Skrypt pomocniczy pozwalający utworzenie paczki zmian gotowych do instalacji.
######################################################################
# SOURCE_PATH - katalog z projektem, w którym tworzone są zmiany.
export SOURCE_PATH="../superset"
# TARGET_PATH - katalog z gotowymi poprawkami.
export TARGET_PATH="fixes-src"

# Funkcja "make taraget dir"
mktdir () {
	echo "-> Make Target Dir $1"
	mkdir -p ${TARGET_PATH}${1}
}

upload () {
	echo "-> Copy fixed file $1"
	scp ${SOURCE_PATH}${1} ${TARGET_PATH}${1}
}



# Zmiany w skryptach Docker'a'
mktdir /
upload /docker-compose.yml
mktdir /docker
upload /docker/.env
upload /docker/docker-frontend.sh
mktdir /docker/nginx/templates
upload /docker/nginx/templates/superset.conf.template
mktdir /docker/pythonpath_dev
upload /docker/pythonpath_dev/superset_config.py
mktdir /docker/superset-websocket
upload /docker/superset-websocket/config.json

# Zmiany w skryptach aplikacji backendu SuperSet
mktdir /superset/initialization
upload /superset/initialization/__init__.py
#upload /superset/app.py
upload /superset/config.py

# Zmiany w skryptach aplikacji frontendu SuperSet
mktdir /superset-frontend 
upload /superset-frontend/package.json
upload /superset-frontend/webpack.config.js
upload /superset-frontend/webpack.proxy-config.js
mktdir /superset-frontend/src/pages/Login
upload /superset-frontend/src/pages/Login/index.tsx
mktdir /superset-frontend/src/views
upload /superset-frontend/src/views/routes.tsx
mktdir /superset-frontend/packages/superset-ui-core/src/connection
upload /superset-frontend/packages/superset-ui-core/src/connection/SupersetClientClass.ts

#mktdir /superset-websocket
#upload /superset-websocket/Dockerfile

exit 0