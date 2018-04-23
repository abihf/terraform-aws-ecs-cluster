output "name" {
  description = "The name of ECS Cluster"
  value       = "${aws_ecs_cluster.cluster.name}"
}

output "arn" {
  description = "The arn of ECS Cluster"
  value       = "${aws_ecs_cluster.cluster.id}"
}

output "asg_arn" {
  description = "The arn of Autoscaling group"
  value       = "${aws_autoscaling_group.asg.arn}"
}

output "asg_name" {
  description = "The arn of Autoscaling group"
  value       = "${aws_autoscaling_group.asg.name}"
}

output "launch_config" {
  description = "Repo url for docker pull and push"
  value       = "${aws_launch_configuration.launch.id}"
}

output "instance_sg" {
  description = "Security group of the launch configuration"
  value       = "${aws_security_group.instance.id}"
}

output "instance_profile" {
  description = "Instance profile that associated with launch config"
  value       = "${aws_iam_instance_profile.ecs.arn}"
}

output "instance_role" {
  description = "IAM role that associated with instance profile"
  value       = "${aws_iam_role.ecs.arn}"
}

output "shared_lb_sg" {
  description = "Precreated security group that should be used by service load balancer"
  value       = "${aws_security_group.lb.id}"
}
