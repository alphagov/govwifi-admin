#!/bin/bash

set -e -u -o pipefail

./govwifi-admin/ci/tasks/scripts/with-docker.sh

cd govwifi-admin

make lint

