variable "aws_region" {
  type = string
}

variable "ubuntu22arm_parent_image" {
  type = string
}

variable "infrastructure_instance_types" {
  type = string
}

variable "launch_target_account_ids" {
  type = list(string)
}
