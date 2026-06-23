output "network_name" {
  description = "Name of the created libvirt network."
  value       = libvirt_network.this.name
}

output "network_id" {
  description = "ID (URI) of the created libvirt network."
  value       = libvirt_network.this.id
}

output "gateway" {
  description = "Gateway address of the network (first host in the CIDR block)."
  value       = local.gateway
}
