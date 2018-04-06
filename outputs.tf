output "name" {
  description = "The name of ECS Cluster"
  value       = "${module.cluster.name}"
}

output "arn" {
  description = "The arn of ECS Cluster"
  value       = "${module.cluster.arn}"
}

output "asg_arn" {
  description = "The arn of Autoscaling group"
  value       = "${module.cluster.asg_arn}"
}

output "asg_name" {
  description = "The arn of Autoscaling group"
  value       = "${module.cluster.asg_name}"
}

output "launch_config" {
  description = "Repo url for docker pull and push"
  value       = "${module.cluster.launch_config}"
}

output "instance_sg" {
  value = "${module.cluster.instance_sg}"
}

output "instance_profile" {
  value = "${module.cluster.instance_profile}"
}

output "instance_role" {
  value = "${module.cluster.instance_role}"
}

output "shared_lb_sg" {
  value = "${module.cluster.shared_lb_sg}"
}
