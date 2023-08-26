resource "aws_apprunner_service" "main" {
  service_name = "apprunner-java-xray-${var.workload}"

  instance_configuration {
    cpu               = var.cpu
    memory            = var.mem
    instance_role_arn = var.instance_role_arn
  }

  network_configuration {
    egress_configuration {
      egress_type = "DEFAULT"
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
      image_identifier      = "${var.repository_url}:latest"
      image_repository_type = "ECR"
    }

    authentication_configuration {
      access_role_arn = var.access_role_arn
    }
  }

  health_check_configuration {
    path = "/actuator/health"
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
