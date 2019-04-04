#!/bin/bash

./govwifi-admin/ci/tasks/scripts/with-docker.sh

cd govwifi-admin || exit

[[ -f "../govwifi-admin-prebuilt-cached/image.tar" ]] && docker load "../govwifi-admin-prebuilt-cached/image.tar"


make prebuild
# needed to register the image container with compose
docker-compose up --no-start
docker tag "$(docker-compose images -q app)" "govwifi-admin-app-prebuilt"
docker save "govwifi-admin-app-prebuilt" -o "../govwifi-admin-prebuilt/image.tar"
cp "../govwifi-admin-prebuilt/image.tar" "../govwifi-admin-prebuilt-cached/image.tar"

