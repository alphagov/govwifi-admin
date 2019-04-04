#!/bin/bash

source /docker-helpers.sh
start_docker

docker load -i mysql-image/image.tar &
docker load -i nginx-image/image.tar &
docker load -i ruby-image/image.tar &
[[ -f "govwifi-admin-prebuilt/image.tar" ]] && docker load -i "govwifi-admin-prebuilt/image.tar" &

wait
