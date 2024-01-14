terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.32.1"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_ecr_repository" "app" {
  name                 = "ecr-apprunner-java-xray"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
}

module "iam" {
  source = "./modules/iam"
}

module "apprunner_public" {
  source            = "./modules/public"
  count             = var.app_runner_workload == "PUBLIC" ? 1 : 0
  workload          = "public"
  cpu               = var.app_runner_cpu
  mem               = var.app_runner_memory
  instance_role_arn = module.iam.instance_role_arn
  access_role_arn   = module.iam.access_role_arn
  repository_url    = aws_ecr_repository.app.repository_url
}

module "apprunner_private" {
  source            = "./modules/private"
  count             = var.app_runner_workload == "PUBLIC_WITH_VPC" ? 1 : 0
  aws_region        = var.aws_region
  workload          = "private"
  cpu               = var.app_runner_cpu
  mem               = var.app_runner_memory
  instance_role_arn = module.iam.instance_role_arn
  access_role_arn   = module.iam.access_role_arn
  repository_url    = aws_ecr_repository.app.repository_url
}

resource "aws_xray_sampling_rule" "app" {
  rule_name      = "JavaApp"
  priority       = 100
  version        = 1
  reservoir_size = 1
  fixed_rate     = 1
  url_path       = "*"
  host           = "*"
  http_method    = "*"
  service_type   = "*"
  service_name   = "*"
  resource_arn   = "*"
}
