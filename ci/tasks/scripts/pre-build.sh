#!/bin/bash

./govwifi-admin/ci/tasks/scripts/with-docker.sh

cd govwifi-admin || exit

make build
docker save "$(docker-compose images -q app)" -o "../govwifi-admin-prebuilt/image.tar"

cd / || exit
