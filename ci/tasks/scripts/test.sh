#!/bin/bash

set -e -u -o pipefail

./src/ci/tasks/scripts/with-docker.sh

workspace_dir="${PWD}"
cd src

make test

cd "${workspace_dir}"
