output "lambda_arn" {
  value = "${aws_lambda_function.asg_hook_handler.arn}"
}
