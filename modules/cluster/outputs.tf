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
  value = "${aws_security_group.instance.id}"
}

output "instance_profile" {
  value = "${aws_iam_instance_profile.ecs.arn}"
}

output "instance_role" {
  value = "${aws_iam_role.ecs.arn}"
}

output "shared_lb_sg" {
  value = "${aws_security_group.lb.id}"
}
