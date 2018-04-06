#!/bin/sh

(
  echo ECS_CLUSTER=${cluster_name}
  echo ECS_ENABLE_TASK_IAM_ROLE=true
  echo ECS_DISABLE_IMAGE_CLEANUP=false
  echo ECS_ENGINE_TASK_CLEANUP_WAIT_DURATION=1h
) > /etc/ecs/ecs.config
