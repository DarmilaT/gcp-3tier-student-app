variable "project_name" {
  type        = string
  description = "The display name of the project"
}

variable "project_id" {
  type        = string
  description = "A unique ID for the project"
}

variable "billing_account_id" {
  type        = string
  description = "ID of the billing account to associate with the project"
}
