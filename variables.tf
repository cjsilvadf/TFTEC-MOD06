variable "resource_group" {
  description = "Default resource group name that the network will be created in."
  type        = string
}

variable "az_rg_region" {
  type        = string
  description = "Localização dos recursos do azure"
}

variable "vnet_name" {
  type = string
}
variable "address_vnet" {
  type = list(any)
}
variable "subnet_name_SUB01" {
  type = string
}
variable "subnet_name_SUB02" {
  type = string
}
variable "address_prefix_subnet_SUB01" {
  type = list(any)
}
variable "address_prefix_subnet_SUB02" {
  type = list(any)
}
variable "nsg_name" {
  type = string
}
variable "tags" {
  type        = map(any)
  description = "Tags nos Recursos e Serviços do azure"
  default = {
    Departamento = "TI"
    responsavel  = "Cleiton José"
    Ambiente     = "Treinamento TFTEC AZ-104"
    MOD          = "06"

  }
}
variable "vm_name_sub01" {
  type = string
}      
variable "vm_name_sub02" {
  type = string
}      

variable "admin_login" {
  description = "admin login"
  type        = string
}

variable "admin_password" {
  description = "admin password" 
  type        = string
}

variable "vmsize_web" {
  type    = string
  
}
