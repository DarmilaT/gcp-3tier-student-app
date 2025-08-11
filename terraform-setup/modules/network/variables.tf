variable "network_name" {
  default = "custom-vpc"
}

variable "region" {
  type    = string
  description = "The region where the network resources will be created"
}

variable "project_id" {
  type        = string
  description = "The ID of the Google Cloud project"
}