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
