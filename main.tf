module "cluster" {
  source = "modules/cluster"

  cluster_name   = "${var.cluster_name}"
  environment    = "${var.environment}"
  product_domain = "${var.product_domain}"

  ec2_ami       = "${var.ec2_ami}"
  instance_type = "${var.instance_type}"
  min_size      = "${var.min_size}"
  max_size      = "${var.max_size}"

  key_name    = "${var.key_name}"
  instance_sg = "${var.instance_sg}"

  vpc_id  = "${var.vpc_id}"
  subnets = "${var.subnets}"

  log_retention = "${var.log_retention}"
}

module "scaling_policy" {
  source = "modules/scaling-policy"

  asg_name     = "${module.cluster.asg_name}"
  cluster_name = "${var.cluster_name}"
}

module "scaledown_handler" {
  source = "modules/scaledown-handler"

  asg_name = "${module.cluster.asg_name}"

  cluster_name   = "${var.cluster_name}"
  environment    = "${var.environment}"
  product_domain = "${var.product_domain}"
}
