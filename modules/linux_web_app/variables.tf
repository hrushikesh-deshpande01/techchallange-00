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

variable "service_plan" {
  description = "name of service_plan"
  type        = string
  default     = ""
}

variable "linux_web_app" {
  description = "name of linux_web_app"
  type        = string
  default     = ""
}

variable "app_command_line" {
  description = "Script to trigger the application"
  type        = string
  default     = "/home/site/wwwroot/launch.sh"
}
variable "node_version" {
  description = "node version"
  type        = string
  default     = "null"
   nullable    = true
  }

  variable "java_version" {
  description = "java version"
  type        = string
  default     = "null"
   nullable    = true
  }


variable "java_server_version" {
  description = "java server version"
  type        = string
  default     = "null"
   nullable    = true
  }

  variable "java_server" {
  description = "java server name "
  type        = string
  default     = "null"
   nullable    = true
  }

  variable "php_version" {
  description = "php version "
  type        = string
  default     = "null"
   nullable    = true
  }

  variable "go_version" {
  description = "go version "
  type        = string
  default     = "null"
   nullable    = true
  }
  variable "python_version" {
  description = "python version "
  type        = string
  default     = "null"
   nullable    = true
  }
variable "key_vault_name" {
  type        = string
  description = "Enter name of keyvault"
  default     = ""
}






