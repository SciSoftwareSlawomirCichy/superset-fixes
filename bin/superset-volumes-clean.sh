#!/bin/bash
#
export COMPOSE_PROJECT_NAME=superset
export SUPERSET_HOME="../../superset-6.0-sci"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# echo "Script dir: ${SCRIPT_DIR}"
# Change dir to main project dir, where docker configuration files are located
export PROJECT_HOME="${SCRIPT_DIR}/.."

echo "Removing data from SuperSet volumes..."
source ${SUPERSET_HOME}/docker/.env

if [[ -n "${VOLUME_SUPERSET_HOME}" ]]; then
  rm -rf ${VOLUME_SUPERSET_HOME}/*
  echo "${VOLUME_SUPERSET_HOME}/*: removed"
else
  echo "⚠️ Variable VOLUME_SUPERSET_HOME is not set."
fi

if [[ -n "${VOLUME_SUPERSET_DATA}" ]]; then
  rm -rf ${VOLUME_SUPERSET_DATA}/*
  echo "${VOLUME_SUPERSET_DATA}/*: removed"
else
  echo "⚠️ Variable VOLUME_SUPERSET_DATA is not set."
fi

if [[ -n "${VOLUME_DB_HOME}" ]]; then
  rm -rf ${VOLUME_DB_HOME}/*
  echo "${VOLUME_DB_HOME}/*: removed"
else
  echo "⚠️ Variable VOLUME_DB_HOME is not set."
fi

if [[ -n "${VOLUME_REDIS_HOME}" ]]; then
  rm -rf ${VOLUME_REDIS_HOME}/*
  echo "${VOLUME_REDIS_HOME}/*: removed"
else
  echo "⚠️ Variable VOLUME_REDIS_HOME is not set."
fi

if [[ -n "${VOLUME_WEBSOCKET_NMP}" ]]; then
  rm -rf ${VOLUME_WEBSOCKET_NMP}/*
  echo "${VOLUME_WEBSOCKET_NMP}/*: removed"
else
  echo "⚠️ Variable VOLUME_WEBSOCKET_NMP is not set."
fi

if [[ -n "${VOLUME_NGINX_LOGS}" ]]; then
  rm -rf ${VOLUME_NGINX_LOGS}/*
  echo "${VOLUME_NGINX_LOGS}/*: removed"
else
  echo "⚠️ Variable VOLUME_NGINX_LOGS is not set."
fi

echo "Done"
exit 0