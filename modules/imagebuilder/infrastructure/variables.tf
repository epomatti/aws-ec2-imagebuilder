variable "workload" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "instance_profile_name" {
  type = string
}

variable "instance_types" {
  type = list(string)
}
