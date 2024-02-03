resource "aws_launch_template" "default" {
  name          = "tailscale-imagebuilder"
  ebs_optimized = true
  instance_type = "t4g.micro"
  user_data     = filebase64("${path.module}/userdata.sh")

  iam_instance_profile {
    name = aws_iam_instance_profile.default.name
  }

  metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "required"
    instance_metadata_tags = "enabled" # TODO: Check what this is
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.elb.id]
    delete_on_termination       = true
  }

  placement {
    availability_zone = var.vpc_availability_zone_placement
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "tailscale-launch-test"
    }
  }
}


### IAM ###
resource "aws_iam_instance_profile" "default" {
  name = "tailscale-launch-instance-profile"
  role = aws_iam_role.default.id
}

resource "aws_iam_role" "default" {
  name = "tailscale-launch-test"

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

resource "aws_iam_role_policy_attachment" "AmazonSSMManagedInstanceCore" {
  role       = aws_iam_role.default.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "AmazonSSMReadOnlyAccess" {
  role       = aws_iam_role.default.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
  role       = aws_iam_role.default.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}


### Security Group ###
data "aws_vpc" "selected" {
  id = var.vpc_id
}

locals {
  vpc_cidr_blocks = [data.aws_vpc.selected.cidr_block]
}

resource "aws_security_group" "elb" {
  name   = "ec2-sg-tailscale-launch-test"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "outbound_http" {
  description       = "HTTP Outbound"
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.elb.id
}

resource "aws_security_group_rule" "outbound_https" {
  description       = "HTTPS Outbound"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.elb.id
}
