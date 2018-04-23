#!/bin/sh

(
  echo ECS_CLUSTER=${cluster_name}
  echo ECS_ENABLE_TASK_IAM_ROLE=true
  echo ECS_ENABLE_TASK_IAM_ROLE_NETWORK_HOST=true
  echo ECS_DISABLE_IMAGE_CLEANUP=false
  echo ECS_ENGINE_TASK_CLEANUP_WAIT_DURATION=1h
  echo ECS_ENABLE_CONTAINER_METADATA=true
  echo ECS_AWSVPC_BLOCK_IMDS=true
  echo ECS_AVAILABLE_LOGGING_DRIVERS='["json-file","awslogs"]'
) > /etc/ecs/ecs.config

# enable container metadata
iptables --insert FORWARD 1 --in-interface docker+ --destination 169.254.169.254/32 --jump DROP
