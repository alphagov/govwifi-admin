#!/bin/bash

set -v -e -u -o pipefail

./govwifi-admin/ci/tasks/scripts/with-docker.sh

cd govwifi-admin

make test

cd /
