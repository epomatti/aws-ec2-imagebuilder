resource "aws_imagebuilder_distribution_configuration" "default" {
  name = "Tailscale Distribution"

  distribution {
    region = var.aws_region

    ami_distribution_configuration {
      name = "tailscale-{{ imagebuilder:buildDate }}"
      # target_account_ids = var.target_account_ids
    }
  }
}
