resource "openstack_networking_secgroup_v2" "runner" {
  name                 = "${terraform.workspace}-runner-lb"
  description          = "runner lb"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "egress" {
  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.runner.id
}

resource "openstack_networking_secgroup_rule_v2" "runner-lb-http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "80"
  port_range_max    = "80"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.runner.id
}

resource "openstack_networking_port_v2" "runner" {
  name           = "${terraform.workspace}-runner-lb"
  network_id     = var.network_id
  port_security_enabled = true
  security_group_ids = [
    openstack_networking_secgroup_v2.runner.id
  ]
  no_security_groups = false
  fixed_ip {
    subnet_id = var.subnet_id
  }
}

resource "openstack_lb_loadbalancer_v2" "runner" {
  name           = "${terraform.workspace}-runner"
  vip_port_id    = openstack_networking_port_v2.runner.id
  admin_state_up = true
  security_group_ids = [
    openstack_networking_secgroup_v2.runner.id
  ]
  depends_on = [
    openstack_networking_port_v2.runner,
    openstack_networking_secgroup_v2.runner
  ]
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

