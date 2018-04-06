# Default disk size for Docker is 22 gig, see http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
resource "aws_launch_configuration" "launch" {
  name_prefix          = "${var.cluster_name}-"
  image_id             = "${var.ec2_ami}"
  instance_type        = "${var.instance_type}"
  security_groups      = ["${concat(list(aws_security_group.instance.id), var.instance_sg)}"]
  user_data            = "${data.template_cloudinit_config.config.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs.id}"
  key_name             = "${var.key_name}"

  # aws_launch_configuration can not be modified.
  # Therefore we use create_before_destroy so that a new modified aws_launch_configuration can be created
  # before the old one get's destroyed. That's why we use name_prefix instead of name.
  lifecycle {
    create_before_destroy = true
  }
}

#==============================================================================
# CLOUD INIT

data "template_cloudinit_config" "config" {
  # gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.cloudinit_ecs.rendered}"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.cloudinit_cloudwatch.rendered}"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "${file("${path.module}/templates/cloudinit/ntp.sh")}"
  }
}

data "template_file" "cloudinit_ecs" {
  template = "${file("${path.module}/templates/cloudinit/ecs.sh")}"

  vars {
    cluster_name = "${var.cluster_name}"
  }
}

data "template_file" "cloudinit_cloudwatch" {
  template = "${file("${path.module}/templates/cloudinit/cloudwatch.sh")}"

  vars {
    cluster_name = "${var.cluster_name}"
  }
}
