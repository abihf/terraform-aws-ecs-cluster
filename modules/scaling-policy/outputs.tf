output "arn" {
  description = "The ARN of created Auto Scaling Group policy"
  value       = "${aws_autoscaling_policy.policy.arn}"
}
