variable "project_id" {
  type        = string
  description = "A unique ID for the project"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "project_name" {
  type        = string
  description = "The display name of the project"
}

variable "billing_account_id" {
  type        = string
  description = "ID of the billing account to associate with the project"
}

variable "zone" {
  type        = string
  description = "The zone where the network resources will be created"
}