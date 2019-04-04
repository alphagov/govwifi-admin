#!/bin/bash

./govwifi-admin/ci/tasks/scripts/with-docker.sh

cd govwifi-admin || exit

[[ -f "../govwifi-admin-prebuilt-cached/image.tar" ]] && docker load -i "../govwifi-admin-prebuilt-cached/image.tar"


make prebuild
docker tag "$(docker-compose images -q app)" "govwifi-admin-app-prebuilt"
docker save "govwifi-admin-app-prebuilt" -o "../govwifi-admin-prebuilt/image.tar"
cp "../govwifi-admin-prebuilt/image.tar" "../govwifi-admin-prebuilt-cached/image.tar"

