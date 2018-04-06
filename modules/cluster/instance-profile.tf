resource "aws_iam_instance_profile" "ecs" {
  name = "profile-${var.cluster_name}-ecs"
  path = "/"
  role = "${aws_iam_role.ecs.name}"
}

resource "aws_iam_role" "ecs" {
  name               = "profile-${var.cluster_name}-ecs"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ec2_assume_policy.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_policy" {
  role       = "${aws_iam_role.ecs.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

data "aws_iam_policy_document" "ec2_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
