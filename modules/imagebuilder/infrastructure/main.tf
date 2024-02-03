resource "aws_imagebuilder_infrastructure_configuration" "default" {
  name                          = "Tailscale-Infrastructure-Configuration"
  description                   = "Infrastructure Configuration for Tailscale"
  instance_profile_name         = var.instance_profile_name
  instance_types                = var.instance_types
  security_group_ids            = [aws_security_group.default.id]
  subnet_id                     = var.subnet_id
  terminate_instance_on_failure = true

  instance_metadata_options {
    http_tokens = "required"
  }

  depends_on = [
    aws_security_group_rule.http,
    aws_security_group_rule.https
  ]
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

resource "aws_security_group" "default" {
  name        = "${var.workload}-sg"
  description = "Controls access for EC2 via Session Manager"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.workload}-sg"
  }
}

resource "aws_security_group_rule" "http" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "https" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}
