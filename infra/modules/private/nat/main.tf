resource "aws_iam_instance_profile" "nat_instance" {
  name = "${var.workload}-nat-intance"
  role = aws_iam_role.nat_instance.id
}

data "aws_subnet" "selected" {
  id = var.subnet
}

resource "aws_instance" "nat_instance" {
  ami           = "ami-08fdd91d87f63bb09"
  instance_type = "t4g.nano"

  associate_public_ip_address = true
  subnet_id                   = var.subnet
  vpc_security_group_ids      = [aws_security_group.nat_instance.id]

  availability_zone    = data.aws_subnet.selected.availability_zone
  iam_instance_profile = aws_iam_instance_profile.nat_instance.id
  user_data            = file("${path.module}/userdata.sh")

  source_dest_check = false

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  monitoring = false

  ebs_optimized = false

  root_block_device {
    encrypted = true
  }

  lifecycle {
    ignore_changes = [
      ami,
      associate_public_ip_address,
      user_data
    ]
  }

  tags = {
    Name = "${var.workload}-nat"
  }
}

### NAT Instance Routes ###

resource "aws_route" "nat" {
  for_each               = toset(var.route_tables)
  route_table_id         = each.key
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.nat_instance.primary_network_interface_id
}

### IAM Role ###

resource "aws_iam_role" "nat_instance" {
  name = "${var.workload}-nat"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

data "aws_iam_policy" "AmazonSSMManagedInstanceCore" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm-managed-instance-core" {
  role       = aws_iam_role.nat_instance.name
  policy_arn = data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn
}

resource "aws_security_group" "nat_instance" {
  name        = "ec2-ssm-${var.workload}-nat"
  description = "Controls access for EC2 via Session Manager"
  vpc_id      = var.vpc_id

  tags = {
    Name = "sg-ssm-${var.workload}-nat"
  }
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_security_group_rule" "allow_ingress_vpc_http" {
  description       = "Allow VPC HTTP ingress"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = [data.aws_vpc.selected.cidr_block]
  ipv6_cidr_blocks  = []
  security_group_id = aws_security_group.nat_instance.id
}

resource "aws_security_group_rule" "allow_ingress_vpc_https" {
  description       = "Allow VPC HTTPS ingress"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = [data.aws_vpc.selected.cidr_block]
  ipv6_cidr_blocks  = []
  security_group_id = aws_security_group.nat_instance.id
}

resource "aws_security_group_rule" "allow_egress_internet_http" {
  description       = "Allow VPC HTTP egress"
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:aws-ec2-no-public-egress-sgr
  ipv6_cidr_blocks  = []
  security_group_id = aws_security_group.nat_instance.id
}

resource "aws_security_group_rule" "allow_egress_internet_https" {
  description       = "Allow VPC HTTPS egress"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:aws-ec2-no-public-egress-sgr
  ipv6_cidr_blocks  = []
  security_group_id = aws_security_group.nat_instance.id
}
