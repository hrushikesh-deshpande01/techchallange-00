variable "location" {
  description = "location of resouce group"
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "name of resouce group"
  type        = string
  default     = ""
}

variable "virtual_network_name" {
  description = "name of virtual network"
  type        = string
  default     = ""
}

variable "subnet1_name" {
  description = "name of Subnet1"
  type        = string
  default     = ""
}

variable "subnet2_name" {
  description = "name of Subnet2"
  type        = string
  default     = ""
}

variable "route_table_name" {
  description = "name of route_table"
  type        = string
  default     = ""
}

variable "mssql_managed_instance_name" {
  description = "name of mssql_managed_instance"
  type        = string
  default     = ""
}


variable "sku_name" {
  type        = string
  description = "Enter SKU"
  default     = "GP_Gen5"
}

variable "license_type" {
  type        = string
  description = "Enter license type"
  default     = "BasePrice"
}

variable "vcores" {
  type        = number
  description = "Enter number of vCores you want to deploy"
  default     = 8
}

variable "storage_size_in_gb" {
  type        = number
  description = "Enter storage size in GB"
  default     = 32
}

variable "key_vault_name" {
  type        = string
  description = "Enter name of keyvault"
  default     = ""
}





