#!/bin/sh

BASE_SERVER_PATH="/data/PROJECT-NAME/deploy"

BASE_LOCAL_PATH="."
DEV_LOCAL_PATH="${BASE_LOCAL_PATH}/dev"
PROD_LOCAL_PATH="${BASE_LOCAL_PATH}/prod"

if [ "$1" = "--prod" ]; then
  PREFIX="prod"
  MODE_LOCAL_PATH=$PROD_LOCAL_PATH
elif [ "$1" = "--dev" ]; then
  PREFIX="dev"
  MODE_LOCAL_PATH=$DEV_LOCAL_PATH
else
  echo "UNKNOWN MODE"
  exit 1
fi

echo "MODE: ${PREFIX}"

scp "${BASE_LOCAL_PATH}/docker-compose.${PREFIX}.yaml" "${SERVER_USER}"@"${SERVER_HOST}":${BASE_SERVER_PATH}
scp "${BASE_LOCAL_PATH}/get-config-versions.py" "${SERVER_USER}"@"${SERVER_HOST}":${BASE_SERVER_PATH}
scp -rp ${MODE_LOCAL_PATH}/ "${SERVER_USER}"@"${SERVER_HOST}":${BASE_SERVER_PATH}/
