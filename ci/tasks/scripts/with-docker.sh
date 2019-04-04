#!/bin/bash

source /docker-helpers.sh
start_docker

ls -lsa govwifi-admin-prebuilt-cached || echo "failed to find cached prebuilt"

docker load -i mysql-image/image.tar
docker load -i nginx-image/image.tar
docker load -i ruby-image/image.tar
[[ -f "govwifi-admin-prebuilt/image.tar" ]] && docker load "govwifi-admin-prebuilt/image.tar"
