#!/bin/bash

set -v -e -u -o pipefail

source /docker-helpers.sh
start_docker

function load_layers() {
  echo "loading docker layer cache"
  pids=
  docker load -qi mysql-image/image.tar & pids[0]=$!
  docker load -qi nginx-image/image.tar & pids[1]=$!
  docker load -qi ruby-image/image.tar & pids[2]=$!
  [[ -f "govwifi-admin-prebuilt/image.tar" ]] && docker load -qi "govwifi-admin-prebuilt/image.tar" & pids[3]=$!

  for pid in ${pids[*]}; do
    wait "$pid"
  done
}
load_layers
