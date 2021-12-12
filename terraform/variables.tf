# AZURE TARGET
variable "target_subscription_id" {
  description = "id of subscription to deploy resources to"
  type        = string
}

variable "target_resource_group_name" {
  description = "name of resource group to deploy resources to"
  type        = string
}

variable "function_name" {
  description = "name of the function"
  type        = string
}

variable "default_location" {
  description = "default azure location"
  type        = string
}
