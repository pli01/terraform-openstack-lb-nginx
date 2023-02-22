variable "subnet_id" {}
variable "network_id" {}
variable "runner_floating_ip" {}
variable "runner_address" {
  type = list(string)
}

variable "lb_protocol" {
  type    = string
  default = "HTTP"
}
variable "lb_listener_protocol_port" {
  type    = number
  default = 80
}
variable "lb_member_protocol_port" {
  type    = number
  default = 80
}

variable "lb_method" {
  type    = string
  default = "ROUND_ROBIN"
}

