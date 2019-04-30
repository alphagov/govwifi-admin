#!/bin/bash

set -e -u -o pipefail

./src/ci/tasks/scripts/with-docker.sh

workspace_dir="${PWD}"
prebuilt_dir="${workspace_dir}/docker-cache/${PREBUILT_TAG}"
prebuilt_cached_dir="${workspace_dir}/${PREBUILT_CACHED_DIR}"

cd src

make prebuild
docker tag "$(docker-compose images -q app)" "${PREBUILT_TAG}"
docker save "${PREBUILT_TAG}" -o "${prebuilt_dir}/image.tar"
cp "${prebuilt_dir}/image.tar" "${prebuilt_cached_dir}/image.tar"

cd "${workspace_dir}"
