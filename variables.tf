variable "rg_name" {
  type = string
}
variable "rg_location" {
  type = string
}
variable "vnet_name" {
  type = string
}
variable "address_vnet" {
  type = list(any)
}
variable "subnet_names" {
  type = list(any)
}
variable "address_prefix_subnets" {
  type = list(any)
}
variable "nsg_name" {
  type = string
}

variable "tags" {
  type        = map(any)
  description = "Tags nos Recursos e Serviços do azure"
  default = {
    DataClassification = "General"
    Criticalidade      = "Business unit-critical"
    BusinnessUnit      = "Marketing"
    OpsTeam            = "Cloud operations"

  }
}
variable "vm_names" {
  type = list(any)
}

variable "admin_login" {
  type = string
}

variable "admin_password" {
  type = string
}

variable "vmsize_web" {
  type = string
}

variable "lb_name" {
  type = string
}

variable "lb_frontend_ip" {
  type = string
}

variable "lb_backend_pool" {
  type = string
}

variable "lb_rule_name" {
  type = string
}

variable "lb_health_probe" {
  type = string
}

variable "pip_appgw_az104" {
  type = string
}
variable "subnet_name_appgw" {
  type = string
}
variable "address_prefix_subnet_appgw" {
  type = list(any)

}
variable "appgw_name" {
  type = string

}
