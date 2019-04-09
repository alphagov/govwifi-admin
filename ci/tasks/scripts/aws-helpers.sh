#!/bin/bash

function stage_name() {
  local deploy_stage="${DEPLOY_STAGE}"
  [[ "${deploy_stage}" == 'production' ]] && deploy_stage='wifi'

  echo "$deploy_stage"
}

function get_network_config() {
  local cluster_name="${1}"
  local service_name="${2}"

  aws ecs describe-services \
        --cluster "${cluster_name}" \
        --service "${service_name}" \
        --output json \
        --query 'services[0].networkConfiguration'
}

function get_launch_type() {
  local cluster_name="${1}"
  local service_name="${2}"

  aws ecs describe-services \
        --cluster "${cluster_name}" \
        --service "${service_name}" \
        --output text \
        --query 'services[0].launchType'
}

function run_task_with_command() {
  local cluster_name="${1}"
  local service_name="${2}"
  local task_definition="${3}"
  local docker_service_name="${4}"
  local command="${5}"
  local network_config, launch_type

  network_config="$(get_network_config "${cluster_name}" "${service_name}")"
  launch_type="$(get_launch_type "${cluster_name}" "${service_name}")"

  aws ecs run-task \
        --cluster "${cluster_name}" \
        --task-definition "${task_definition}" \
        --launch-type "${launch_type}" \
        --network-configuration "${network_config}" \
        --count 1 \
        --override "$(override_command_structure "${docker_service_name}" "${command}")"
}

function form_command_override() {
  local command="${1}"
  python -c "import json; print(json.dumps('$command'.split()))"
}

function override_command_structure() {
  local docker_service="${1}"
  local command="${2}"

  cat <<EOF
  {
    "containerOverrides": [
      {
        "name": "${docker_service}",
        "command": $(form_command_override "${command}")
      }
    ]
  }
EOF
}

function ecs_deploy() {
  local cluster_name="${1}"
  local service_name="${2}"

  aws ecs update-service \
        --cluster "${cluster_name}" \
        --service "${service_name}" \
        --force-new-deployment
}
