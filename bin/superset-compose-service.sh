#!/bin/bash
#
export COMPOSE_PROJECT_NAME=superset
export SUPERSET_HOME="../../superset-6.0-sci"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# echo "Script dir: ${SCRIPT_DIR}"
# Change dir to main project dir, where docker configuration files are located
export PROJECT_HOME="${SCRIPT_DIR}/.."
cd "${SUPERSET_HOME}"


start() {
  echo "**************************"
  echo "* Starting SuperSet composition... "
  echo "**************************"
  docker compose --env-file docker/.env up -d
}

down() {
  echo "**************************"
  echo "* Stopping SuperSet composition... "
  echo "**************************"
  docker compose --env-file docker/.env down
}

stop() {
  echo "**************************"
  echo "* Stopping SuperSet containers...  "
  echo "**************************"
  # docker compose --env-file docker/.env down
  # Universal command :)
  IFS=$'\n'
  for CONTAINER_ID in `docker container ls | grep ${COMPOSE_PROJECT_NAME} | awk '{print $1}'`
  do
    STOPPED_ID=`docker stop ${CONTAINER_ID}`
    echo "--> Container ${STOPPED_ID} stopped"
  done	
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    *)
        echo "Usage: $0 {start|down|stop}"
esac

exit 0
