#!/bin/bash

source /docker-helpers.sh
start_docker

ls -lsa mysql-image || echo "failed to find mysql-image"

docker load -i mysql-image/image
docker load -i nginx-image/image
docker load -i ruby-image/image
