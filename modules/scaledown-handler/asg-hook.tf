resource "aws_autoscaling_lifecycle_hook" "termination" {
  name                    = "${var.cluster_name}-ecs-asg-termination"
  autoscaling_group_name  = "${var.asg_name}"
  lifecycle_transition    = "autoscaling:EC2_INSTANCE_TERMINATING"
  notification_target_arn = "${aws_sns_topic.asg_hook.arn}"

  heartbeat_timeout = 900
  default_result    = "CONTINUE" # if graceful shutdown failed, force terminate the instance

  role_arn   = "${aws_iam_role.asg_lifecycle.arn}"
  depends_on = ["aws_iam_role_policy_attachment.asg_allow_send_sns"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "asg_lifecycle" {
  name               = "${var.cluster_name}-ecs-asg-hook"
  path               = "/asg/"
  assume_role_policy = "${data.aws_iam_policy_document.asg_assume_policy.json}"
}

data "aws_iam_policy_document" "asg_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["autoscaling.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "asg_allow_send_sns" {
  role       = "${aws_iam_role.asg_lifecycle.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AutoScalingNotificationAccessRole"
}

#==============================================================================
# SNS
resource "aws_sns_topic" "asg_hook" {
  name         = "${var.cluster_name}-asg-termination-hook"
  display_name = "this topic contain information about asg termination hook"
}

resource "aws_sns_topic_subscription" "asg_hook" {
  topic_arn = "${aws_sns_topic.asg_hook.arn}"
  protocol  = "lambda"
  endpoint  = "${aws_lambda_function.asg_hook_handler.arn}"
}
