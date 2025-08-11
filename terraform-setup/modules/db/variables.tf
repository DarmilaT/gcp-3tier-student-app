variable "zone" {
  type        = string
  description = "The zone where the network resources will be created"
}

variable "project_id" {
  type        = string
  description = "A unique ID for the project"
}

variable "subnet" {
  type = string
}