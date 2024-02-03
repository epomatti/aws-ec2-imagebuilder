terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.35.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  workload = "imagebuilder"
}

module "vpc" {
  source     = "./modules/vpc"
  aws_region = var.aws_region
  workload   = local.workload
}

module "iam" {
  source   = "./modules/iam"
  workload = local.workload
}

### Image Builder
module "components" {
  source = "./modules/imagebuilder/components"
}

module "image_recipe" {
  source                  = "./modules/imagebuilder/recipe"
  aws_region              = var.aws_region
  tailscale_component_arn = module.components.tailscale_build_component_arn
  ubunt22arm_parent_image = var.ubuntu22arm_parent_image
}

module "infrastructure" {
  source                = "./modules/imagebuilder/infrastructure"
  workload              = local.workload
  vpc_id                = module.vpc.vpc_id
  subnet_id             = module.vpc.subnet_id
  instance_profile_name = module.iam.instance_profile_name
  instance_types        = var.infrastructure_instance_types
}

module "distribution" {
  source             = "./modules/imagebuilder/distribution"
  aws_region         = var.aws_region
  target_account_ids = var.launch_target_account_ids
}

module "pipeline" {
  source                           = "./modules/imagebuilder/pipeline"
  image_recipe_arn                 = module.image_recipe.image_recipe_arn
  infrastructure_configuration_arn = module.infrastructure.infrastructure_configuration_arn
  distribution_configuration_arn   = module.distribution.distribution_configuration_arn
}

### Launch testing ###
module "ssm" {
  source = "./modules/ssm"
}

module "launch_template" {
  source                          = "./modules/launch-template"
  vpc_availability_zone_placement = module.vpc.az
  vpc_id                          = module.vpc.vpc_id
  subnet_id                       = module.vpc.subnet_id
}
