resource "openstack_lb_loadbalancer_v2" "runner" {
  name           = "${terraform.workspace}-runner"
  vip_subnet_id  = var.subnet_id
  admin_state_up = true
}

resource "openstack_lb_listener_v2" "runner" {
  name            = "${terraform.workspace}-runner-listener"
  protocol        = var.lb_protocol
  protocol_port   = var.lb_listener_protocol_port
  loadbalancer_id = openstack_lb_loadbalancer_v2.runner.id
}

resource "openstack_lb_pool_v2" "runner" {
  name = "${terraform.workspace}-runner-lb_pool"

  protocol    = var.lb_protocol
  lb_method   = var.lb_method
  listener_id = openstack_lb_listener_v2.runner.id
}

resource "openstack_lb_member_v2" "runner" {
  name          = "${terraform.workspace}-runner-member-${element(var.runner_address, count.index)}"
  count         = length(var.runner_address)
  address       = element(var.runner_address, count.index)
  pool_id       = openstack_lb_pool_v2.runner.id
  subnet_id     = var.subnet_id
  protocol_port = var.lb_member_protocol_port
}

resource "openstack_networking_floatingip_associate_v2" "runner" {
  floating_ip = var.runner_floating_ip
  port_id     = openstack_lb_loadbalancer_v2.runner.vip_port_id
  depends_on  = [openstack_lb_loadbalancer_v2.runner]
}

