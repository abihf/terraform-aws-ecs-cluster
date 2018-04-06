# Instances are scaled across availability zones http://docs.aws.amazon.com/autoscaling/latest/userguide/auto-scaling-benefits.html
resource "aws_autoscaling_group" "asg" {
  name = "${var.cluster_name}-${random_id.asg.b64_url}"

  vpc_zone_identifier  = "${var.subnets}"
  launch_configuration = "${aws_launch_configuration.launch.id}"

  force_delete     = false
  desired_capacity = "${var.min_size}"
  min_size         = "${var.min_size}"
  max_size         = "${var.max_size}"

  termination_policies = ["OldestLaunchConfiguration", "OldestInstance"]

  tag {
    key                 = "Application"
    value               = "docker"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Cluster"
    value               = "${var.cluster_name}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Service"
    value               = "${var.cluster_name}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-asg"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "Environment"
    value               = "${var.environment}"
    propagate_at_launch = "true"
  }

  tag {
    key                 = "ProductDomain"
    value               = "${var.product_domain}"
    propagate_at_launch = "true"
  }

  lifecycle {
    create_before_destroy = true
  }

  # wait until ecs cluster has been created and required permission for instance profile
  # has been attached
  depends_on = [
    "aws_ecs_cluster.cluster",
    "aws_iam_role_policy_attachment.ecs_policy",
  ]
}

resource "random_id" "asg" {
  byte_length = 6

  keepers = {
    name = "${var.cluster_name}"
    lc   = "${aws_launch_configuration.launch.id}"
  }
}
