#!/bin/bash

 source govwifi-admin/ci/tasks/scripts/aws-helpers.sh

function migrate() {
  local migration_command="bundle exec rake db:migrate"
  local docker_service_name="admin"
  local aws_service_cmd, cluster_name, service_name, task_definition, docker_service_name, deploy_stage

  deploy_stage="$(stage_name)"
  cluster_name="${deploy_stage}-admin-cluster"
  service_name="admin-${deploy_stage}"
  task_definition="admin-task-${deploy_stage}"

  run_task_with_command \
    "${cluster_name}" \
    "${service_name}" \
    "${task_definition}" \
    "${docker_service_name}" \
    "${migration_command}"
}

migrate
