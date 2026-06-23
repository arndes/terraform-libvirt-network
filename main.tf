locals {
  prefix     = tonumber(split("/", var.cidr)[1])
  gateway    = cidrhost(var.cidr, 1)
  dhcp_start = cidrhost(var.cidr, 2)
  dhcp_end   = cidrhost(var.cidr, -2)
}

resource "libvirt_network" "this" {
  name      = var.name
  autostart = var.autostart

  lifecycle {
    precondition {
      condition     = var.mode != "bridge" || var.bridge != ""
      error_message = "bridge must be set to a non-empty host device name when mode is \"bridge\"."
    }
  }

  # No forward element means isolated mode in libvirt.
  forward = var.mode != "isolated" ? {
    mode = var.mode == "bridge" ? "bridge" : "nat"
  } : null

  bridge = var.mode == "bridge" && var.bridge != "" ? {
    name = var.bridge
  } : null

  ips = [{
    address = local.gateway
    prefix  = local.prefix
    dhcp = var.dhcp_enabled ? {
      ranges = [{
        start = local.dhcp_start
        end   = local.dhcp_end
      }]
    } : null
  }]

  domain = var.domain != "" ? {
    name = var.domain
  } : null
}
