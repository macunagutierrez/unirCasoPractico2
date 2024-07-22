variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region where the resources will be created"
  type        = string
  default     = "West Europe"
}
variable "vm_size" {
  description = "The Azure region where the resources will be created"
  type        = string
  default     = "Standard_D1_v2" # 3.5 GB, 1 CPU
}
