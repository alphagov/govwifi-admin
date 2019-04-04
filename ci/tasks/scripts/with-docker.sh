#!/bin/bash

source /docker-helpers.sh
start_docker

ls -lsa mysql-image || echo "failed to find mysql-image"

docker load -i mysql-image/image.tar
docker load -i nginx-image/image.tar
docker load -i ruby-image/image.tar
if [[ -f "govwifi-admin-prebuilt/image.tar" ]]; then
  mangled_hash="$(docker load -qi govwifi-admin-prebuilt/image.tar)"
  hash="$(echo ${mangled_hash} | grep -hoE 'sha256:.*')"
  docker tag "${hash}" govwifi-admin_app:latest
fi
