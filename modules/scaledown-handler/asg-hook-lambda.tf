resource "aws_lambda_function" "asg_hook_handler" {
  function_name    = "${var.cluster_name}-ecs-scaledown-hook"
  role             = "${aws_iam_role.asg_hook_handler.arn}"
  handler          = "main.handle"
  filename         = "${data.archive_file.asg_hook_handler.output_path}"
  source_code_hash = "${data.archive_file.asg_hook_handler.output_base64sha256}"
  runtime          = "python3.6"

  environment {
    variables = {
      CLUSTER_NAME = "${var.cluster_name}"
    }
  }

  tags {
    Name          = "${var.cluster_name}-ecs-scaledown-hook"
    Service       = "${var.cluster_name}"
    Environment   = "${var.environment}"
    ProductDomain = "${var.product_domain}"
  }
}

data "archive_file" "asg_hook_handler" {
  type        = "zip"
  output_path = ".terraform/tmp/lambda-asg-handler.zip"

  source {
    content  = "${file("${path.module}/files/lambda-asg-hook.py")}"
    filename = "main.py"
  }
}

resource "aws_lambda_permission" "allow_sns" {
  function_name = "${aws_lambda_function.asg_hook_handler.function_name}"
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.asg_hook.arn}"
}

resource "aws_iam_role" "asg_hook_handler" {
  name               = "${var.cluster_name}-ecs-lambda-draining"
  path               = "/lambda/"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_assume_policy.json}"
}

data "aws_iam_policy_document" "lambda_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "asg_hook_lambda_policy" {
  role   = "${aws_iam_role.asg_hook_handler.id}"
  policy = "${data.aws_iam_policy_document.asg_hook_lambda_policy.json}"
}

data "aws_iam_policy_document" "asg_hook_lambda_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "ecs:ListContainerInstances",
      "ecs:DescribeContainerInstances",
      "ecs:UpdateContainerInstancesState",
      "ecs:DescribeTasks",
      "ecs:ListTasks",
      "autoscaling:CompleteLifecycleAction",
      "sns:Publish",
    ]

    resources = [
      "*",
    ]
  }
}
