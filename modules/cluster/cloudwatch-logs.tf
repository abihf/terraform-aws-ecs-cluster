resource "aws_cloudwatch_log_group" "docker_daemon_log" {
  name              = "/tvlk/ecs/${var.cluster_name}/docker-daemon.log"
  retention_in_days = "${var.log_retention}"

  tags {
    Environment   = "${var.environment}"
    ProductDomain = "${var.product_domain}"
  }
}

resource "aws_cloudwatch_log_group" "ecs_init_log" {
  name              = "/tvlk/ecs/${var.cluster_name}/ecs-init.log"
  retention_in_days = "${var.log_retention}"

  tags {
    Environment   = "${var.environment}"
    ProductDomain = "${var.product_domain}"
  }
}

resource "aws_cloudwatch_log_group" "ecs_agent_log" {
  name              = "/tvlk/ecs/${var.cluster_name}/ecs-agent.log"
  retention_in_days = "${var.log_retention}"

  tags {
    Environment   = "${var.environment}"
    ProductDomain = "${var.product_domain}"
  }
}
