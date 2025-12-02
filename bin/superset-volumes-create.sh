#!/bin/bash
#
export COMPOSE_PROJECT_NAME=superset
export SUPERSET_HOME="../../superset-6.0-sci"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# echo "Script dir: ${SCRIPT_DIR}"
# Change dir to main project dir, where docker configuration files are located
export PROJECT_HOME="${SCRIPT_DIR}/.."

echo "Creating dirs for SuperSet volumes..."
source ${SUPERSET_HOME}/docker/.env

mkdir -p ${VOLUME_SUPERSET_HOME}/*
echo "${VOLUME_SUPERSET_HOME}/*: created"

mkdir -p ${VOLUME_SUPERSET_DATA}/*
echo "${VOLUME_SUPERSET_DATA}/*: created"

mkdir -p ${VOLUME_DB_HOME}/*
echo "${VOLUME_DB_HOME}/*: created"

mkdir -p ${VOLUME_REDIS_HOME}/*
echo "${VOLUME_REDIS_HOME}/*: created"

mkdir -p ${VOLUME_WEBSOCKET_NMP}/*
echo "${VOLUME_WEBSOCKET_NMP}/*: created"

mkdir -p ${VOLUME_NGINX_LOGS}/*
echo "${VOLUME_NGINX_LOGS}/*: created"

echo "Done"
exit 0