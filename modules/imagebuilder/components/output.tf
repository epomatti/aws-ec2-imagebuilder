output "tailscale_build_component_arn" {
  value = aws_imagebuilder_component.tailscale.arn
}

output "tailscale_test_component_arn" {
  value = aws_imagebuilder_component.test.arn
}

