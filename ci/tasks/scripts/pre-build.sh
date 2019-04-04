#!/bin/bash

./govwifi-admin/ci/tasks/scripts/with-docker.sh

cd govwifi-admin || exit

make build
# needed to register the image container with compose
docker-compose up --no-start
docker save "govwifi-admin_app" -o "../govwifi-admin-prebuilt/image.tar"

cd / || exit
