resource "aws_imagebuilder_component" "tailscale" {
  name     = "TailscaleUbuntu22"
  platform = "Linux"
  version  = "1.0.0"
  data     = file("${path.module}/tailscale-build.yaml")
}

resource "aws_imagebuilder_component" "test" {
  name     = "ValidateTailscaleUbuntu22"
  platform = "Linux"
  version  = "1.0.0"
  data     = file("${path.module}/tailscale-test.yaml")
}
