#!/bin/bash
######################################################################
# Skrypt pomocniczy pozwalający na wysłanie zmian do maszyny, na której
# testowane jest rozwiązanie. 
######################################################################
# SOURCE_PATH - katalog z projektem, w którym tworzone są zmiany.
export SOURCE_PATH="../superset"
# TARGET_PATH - katalog z projektem, w którym testowane są zmiany.
export TARGET_PATH="root@devops-box-01:/d/workspace/git/superset"

upload () {
	scp ${SOURCE_PATH}${1} ${TARGET_PATH}${1}
}


# Zmiany w skryptach Docker'a'
upload /docker-compose.yml
upload /docker/.env
upload /docker/docker-frontend.sh
upload /docker/nginx/templates/superset.conf.template
upload /docker/pythonpath_dev/superset_config.py
upload /docker/superset-websocket/config.json

# Zmiany w skryptach aplikacji backendu SuperSet
upload /superset/initialization/__init__.py
#upload /superset/app.py
upload /superset/config.py

# Zmiany w skryptach aplikacji frontendu SuperSet 
upload /superset-frontend/package.json
upload /superset-frontend/webpack.config.js
upload /superset-frontend/webpack.proxy-config.js
upload /superset-frontend/src/pages/Login/index.tsx
upload /superset-frontend/src/views/routes.tsx
upload /superset-frontend/packages/superset-ui-core/src/connection/SupersetClientClass.ts

#upload /superset-websocket/Dockerfile

exit 0