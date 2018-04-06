resource "aws_autoscaling_policy" "policy" {
  name                   = "${var.cluster_name}-ecs-scale-policy"
  autoscaling_group_name = "${var.asg_name}"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    customized_metric_specification {
      namespace   = "AWS/ECS"
      metric_name = "CPUReservation"
      statistic   = "Average"

      metric_dimension {
        ClusterName = "${var.cluster_name}"
      }
    }

    target_value = "${var.scaling_target_cpu_reservation}"
  }

  target_tracking_configuration {
    customized_metric_specification {
      namespace   = "AWS/ECS"
      metric_name = "MemoryReservation"
      statistic   = "Average"

      metric_dimension {
        ClusterName = "${var.cluster_name}"
      }
    }

    target_value = "${var.scaling_target_memory_reservation}"
  }
}
