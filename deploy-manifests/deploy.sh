#!/bin/sh

# VARS
BASE_SERVER_PATH="/data/PROJECT-NAME/deploy"
BASE_LOCAL_PATH="."

DEV_STACK_NAME=project_dev
PROD_STACK_NAME=project_prod

# SETUP MODE
if [ "$1" = "--prod" ]; then
  PREFIX="prod"
  MODE_STACK_NAME=$PROD_STACK_NAME
elif [ "$1" = "--dev" ]; then
  PREFIX="dev"
  MODE_STACK_NAME=$DEV_STACK_NAME
else
  echo "UNKNOWN MODE"
  exit 1
fi
echo "MODE: ${PREFIX}"

cd $BASE_SERVER_PATH || exit 1;

# CONFIG VERSIONS
CONFIG_ENV_VARS=$(python3 ./get-config-versions.py "$1")
for env_var in ${CONFIG_ENV_VARS}
do
   export "${env_var?}"
done

# DEPLOY
echo "$REGISTRY_PASSWORD" | docker login "$REGISTRY" --username "$REGISTRY_USER" --password-stdin
docker system prune -f;
docker stack deploy \
  --detach=false \
  --prune \
  --with-registry-auth \
  --compose-file "${BASE_LOCAL_PATH}/docker-compose.${PREFIX}.yaml" ${MODE_STACK_NAME};

# REMOVE UNUSED DOCKER CONFIGS
# Configs used for services will not be deleted automatically
# Fail is allowed due to the presence of the configs used
docker config rm $(docker config ls -q) || exit 0
