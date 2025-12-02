#!/bin/bash
#
export COMPOSE_PROJECT_NAME=portainer-compose

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# echo "Script dir: ${SCRIPT_DIR}"
# Change dir to main project dir, where docker configuration files are located
export PROJECT_HOME="${SCRIPT_DIR}/.."

start() {
  echo "**************************"
  echo "* Starting Portainer.io composition... "
  echo "**************************"
  docker compose -f "${PROJECT_HOME}/portainer-compose.yml" up -d
}

stop() {
  echo "**************************"
  echo "* Stoping Portainer.io composition... "
  echo "**************************"
  docker compose -f "${PROJECT_HOME}/portainer-compose.yml" down
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    *)
        echo "Usage: $0 {start|stop}"
esac

exit 0
