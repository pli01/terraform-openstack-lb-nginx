variable "keypair_name" {
  type    = string
  default = ""
}

variable "fip" {
  type    = string
  default = ""
}


variable "dns_nameservers" {
  type    = list(string)
  default = ["213.186.33.99"]
}

variable "default_cidr" {
  type    = string
  default = "192.168.1.0/24"
}

variable "router_config" {
  type = list(object({
    name      = string
    ip        = string
    extnet    = string
    allow_fip = bool
  }))
  default = [
    { name = "rt_apps", ip = "192.168.1.1", extnet = "Ext-Net", allow_fip = true }
  ]
}

variable "subnet_routes_config" {
  type = list(object({
    destination = string
    nexthop     = string
  }))
  default = [
    { destination = "0.0.0.0/0", nexthop = "192.168.1.1" }
  ]
}

variable "runner_flavor" {
  type    = string
  default = "s1-2"
}

variable "runner_image" {
  type    = string
  default = "Ubuntu 20.04"
}

variable "runner_volume_type" {
  type    = string
  default = "classic"
}

variable "runner_volume_size" {
  type    = number
  default = 0
}
variable "runner_data_volume_size" {
  type    = number
  default = 0
}

variable "runner_name" {
  default = ""
}

variable "runner_count" {
  type    = number
  default = 1
}

variable "http_proxy" {
  type    = string
  default = ""
}
variable "no_proxy" {
  type    = string
  default = ""
}
