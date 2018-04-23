output "lambda_arn" {
  description = "The ARN of created lambda function"
  value       = "${aws_lambda_function.asg_hook_handler.arn}"
}
