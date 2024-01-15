resource "aws_apprunner_service" "main" {
  service_name = "apprunner-java-xray-${var.workload}"

  instance_configuration {
    cpu               = var.cpu
    memory            = var.mem
    instance_role_arn = var.instance_role_arn
  }

  network_configuration {
    egress_configuration {
      egress_type       = "VPC"
      vpc_connector_arn = aws_apprunner_vpc_connector.connector.arn
    }
    ingress_configuration {
      is_publicly_accessible = true
    }
  }

  source_configuration {
    auto_deployments_enabled = true

    image_repository {
      image_configuration {
        port = "8080"
      }
      image_identifier      = "${var.repository_url}:${var.image_tag}"
      image_repository_type = "ECR"
    }

    authentication_configuration {
      access_role_arn = var.access_role_arn
    }
  }

  health_check_configuration {
    protocol = "HTTP"
    path     = "/actuator/health"
  }

  observability_configuration {
    observability_enabled           = true
    observability_configuration_arn = aws_apprunner_observability_configuration.main.arn
  }
}

resource "aws_apprunner_observability_configuration" "main" {
  observability_configuration_name = "awsxray"

  trace_configuration {
    vendor = "AWSXRAY"
  }
}

resource "aws_apprunner_vpc_connector" "connector" {
  vpc_connector_name = "vpcconn-${var.workload}"
  subnets            = module.vpc.private_subnets
  security_groups    = [aws_security_group.main.id]
}

### VPC ###
module "vpc" {
  source     = "./vpc"
  aws_region = var.aws_region
  workload   = "apprunner-xray"
}

module "nat-instance" {
  source       = "./nat"
  workload     = var.workload
  vpc_id       = module.vpc.vpc_id
  subnet       = module.vpc.public_subnets[0]
  route_tables = module.vpc.priv_rts
}

### Security Groups ###
resource "aws_security_group" "main" {
  name        = "apprunner-${var.workload}"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "sg-apprunner-${var.workload}"
  }
}

resource "aws_security_group_rule" "all_egress" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main.id
}

module "xray" {
  source = "../xray"
  host   = aws_apprunner_service.main.service_url
}
