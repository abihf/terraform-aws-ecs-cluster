resource "aws_autoscaling_policy" "cpu" {
  name                   = "${var.cluster_name}-cpu-policy"
  autoscaling_group_name = "${var.asg_name}"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    customized_metric_specification {
      namespace   = "AWS/ECS"
      metric_name = "CPUReservation"
      statistic   = "Average"

      metric_dimension {
        name  = "ClusterName"
        value = "${var.cluster_name}"
      }
    }

    target_value = "${var.scaling_target_cpu_reservation}"
  }
}

resource "aws_autoscaling_policy" "memory" {
  name                   = "${var.cluster_name}-memory-policy"
  autoscaling_group_name = "${var.asg_name}"
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    customized_metric_specification {
      namespace   = "AWS/ECS"
      metric_name = "MemoryReservation"
      statistic   = "Average"

      metric_dimension {
        name  = "ClusterName"
        value = "${var.cluster_name}"
      }
    }

    target_value = "${var.scaling_target_memory_reservation}"
  }
}
