#!/bin/bash

source govwifi-admin/ci/tasks/scripts/aws-helpers.sh

function deploy() {
  local cluster_name, service_name, deploy_stage

  deploy_stage="$(stage_name)"
  cluster_name="${deploy_stage}-admin-cluster"
  service_name="admin-${deploy_stage}"

  ecs_deploy \
    "${cluster_name}" \
    "${service_name}"
}

deploy
