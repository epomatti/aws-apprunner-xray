locals {
  docker_observability_enabled = var.enable_dockerfile_otel_agent ? "1" : "0"
}

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
        runtime_environment_variables = {
          OBSERVABILITY_ENABLED = local.docker_observability_enabled
          # AWS_XRAY_DEBUG_MODE   = var.xray_debug_mode
          # AWS_XRAY_TRACING_NAME = "MyApp"
        }
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
    observability_enabled           = var.enable_apprunner_observability
    observability_configuration_arn = var.enable_apprunner_observability ? aws_apprunner_observability_configuration.main.arn : null
  }
}

resource "aws_apprunner_observability_configuration" "main" {
  observability_configuration_name = "awsxray"

  trace_configuration {
    vendor = "AWSXRAY"
  }
}

# module "xray" {
#   source = "../xray"
#   host   = aws_apprunner_service.main.service_url
# }
