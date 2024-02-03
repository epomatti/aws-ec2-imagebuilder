resource "aws_imagebuilder_component" "tailscale" {
  name     = "Tailscale"
  platform = "Linux"
  version  = "1.0.0"
  data     = yamlencode(file("${path.module}/tailscale.yaml"))
}
