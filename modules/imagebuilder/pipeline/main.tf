resource "aws_imagebuilder_image_pipeline" "default" {
  name                             = "Tailscale"
  image_recipe_arn                 = var.image_recipe_arn
  infrastructure_configuration_arn = var.infrastructure_configuration_arn
  enhanced_image_metadata_enabled  = true

  image_scanning_configuration {
    image_scanning_enabled = true
  }
}
