variable "runner_name" {
  default = ""
}

variable "runner_count" {
  type    = number
  default = 0
}

variable "keypair_name" {
  default = ""
}

variable "flavor" {}
variable "image" {}
variable "volume_type" {}
variable "volume_size" {
  type    = number
  default = 0
}
variable "data_volume_size" {
  type    = number
  default = 0
}

variable "network_id" {}
variable "subnet_id" {}
variable "http_proxy" { default = "" }
variable "no_proxy" { default = "" }
