#!/bin/bash

source /docker-helpers.sh
start_docker

echo "loading docker layer cache"
docker load -qi mysql-image/image.tar &
docker load -qi nginx-image/image.tar &
docker load -qi ruby-image/image.tar &
[[ -f "govwifi-admin-prebuilt/image.tar" ]] && docker load -qi "govwifi-admin-prebuilt/image.tar" &

wait
