#!/bin/sh

BUILD=$(pwd)/build

VERSION_TMP_FILE=${BUILD}/build_version.tmp
DATE=$(date '+%Y%m%d')
GIT_COMMIT=$(git rev-parse HEAD | cut -c 1-8)

mkdir -p build
touch "${VERSION_TMP_FILE}"
echo "${DATE}_${GIT_COMMIT}" > "${VERSION_TMP_FILE}"