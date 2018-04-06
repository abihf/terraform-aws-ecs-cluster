resource "aws_security_group" "instance" {
  name        = "${var.cluster_name}-ecs"
  description = "Allow inbound from lb"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name          = "${var.cluster_name}-ecs"
    Environment   = "${var.environment}"
    ProductDomain = "${var.product_domain}"
    Description   = "Security group to allow inbound from lb"
  }
}

resource "aws_security_group" "lb" {
  name        = "${var.cluster_name}-lbecs"
  description = "placeholder security group for services load balancer"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name          = "${var.cluster_name}-lbecs"
    Environment   = "${var.environment}"
    ProductDomain = "${var.product_domain}"
    Description   = "Shared security group for services load balancer"
  }
}

resource "aws_security_group_rule" "allow_ingress_ephemeral_ports" {
  type                     = "ingress"
  from_port                = 32768
  to_port                  = 60999
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.lb.id}"
  security_group_id        = "${aws_security_group.instance.id}"
}

resource "aws_security_group_rule" "allow_egress_ephemeral_ports" {
  type                     = "egress"
  from_port                = 32768
  to_port                  = 60999
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.instance.id}"
  security_group_id        = "${aws_security_group.lb.id}"
}
