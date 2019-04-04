#!/bin/bash

./govwifi-admin/ci/tasks/scripts/with-docker.sh

cd govwifi-admin || exit

make prebuild
# needed to register the image container with compose
docker-compose up --no-start
docker tag "$(docker-compose images -q app)" "govwifi-admin-app-prebuilt"
docker save "govwifi-admin-app-prebuilt" -o "../govwifi-admin-prebuilt/image.tar"

cd / || exit
