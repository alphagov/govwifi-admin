#!/bin/bash

source /docker-helpers.sh
start_docker

function load_layers() {
  echo "loading docker layer cache"
  pids=
  sleep 5 & pids[0]=$!
  sleep 5 & pids[1]=$!
  sleep 5 & pids[2]=$!
  [[ -f "govwifi-admin-prebuilt/image.tar" ]] && docker load -qi "govwifi-admin-prebuilt/image.tar" & pids[3]=$!

  for pid in ${pids[*]}; do
    wait "$pid"
  done
}
