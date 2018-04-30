output "cpu_policy" {
  description = "The ARN of created Auto Scaling Group policy"
  value       = "${aws_autoscaling_policy.cpu.arn}"
}

output "memory_policy" {
  description = "The ARN of created Auto Scaling Group policy"
  value       = "${aws_autoscaling_policy.memory.arn}"
}
