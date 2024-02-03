resource "aws_imagebuilder_image_pipeline" "default" {
  name                            = "TailscaleUbuntu22"
  enhanced_image_metadata_enabled = true

  image_recipe_arn                 = var.image_recipe_arn
  infrastructure_configuration_arn = var.infrastructure_configuration_arn
  distribution_configuration_arn   = var.distribution_configuration_arn

  image_scanning_configuration {
    image_scanning_enabled = true
  }
}
