#!/bin/bash

source /docker-helpers.sh
start_docker

ls -lsa mysql-image || echo "failed to find mysql-image"

docker load -i mysql-image/image.tar
docker load -i nginx-image/image.tar
docker load -i ruby-image/image.tar
[[ -f "govwifi-admin-prebuilt/image.tar" ]] && docker load -i govwifi-admin-prebuilt/image.tar
