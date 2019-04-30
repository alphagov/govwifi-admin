#!/bin/bash

set -e -u -o pipefail

./src/ci/tasks/scripts/with-docker.sh

workspace_dir="${PWD}"
cd src

make lint

cd "${workspace_dir}"
