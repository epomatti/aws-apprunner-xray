terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_ecr_repository" "app" {
  name                 = "ecr-apprunner-java-xray"
  image_tag_mutability = "MUTABLE"
}

resource "aws_apprunner_service" "main" {
  service_name = "apprunner-java-xray"

  instance_configuration {
    cpu               = var.app_runner_cpu
    memory            = var.app_runner_memory
    instance_role_arn = aws_iam_role.instance_role.arn
  }

  source_configuration {
    auto_deployments_enabled = true

    image_repository {
      image_configuration {
        port = "8080"
      }
      image_identifier      = "${aws_ecr_repository.app.repository_url}:latest"
      image_repository_type = "ECR"
    }

    authentication_configuration {
      access_role_arn = aws_iam_role.access_role.arn
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

### IAM ###

resource "aws_iam_role" "instance_role" {
  name = "AppRunnerXRayInstanceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "tasks.apprunner.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "xray" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}

resource "aws_iam_role" "access_role" {
  name = "AppRunnerXRayAccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "access_role" {
  role       = aws_iam_role.access_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}
