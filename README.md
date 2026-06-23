# module: network

Creates a `libvirt_network` on a KVM hypervisor. Supports three modes: NAT, isolated, and bridge.

## Usage

### NAT network with DHCP

```hcl
module "net" {
  source = "github.com/arndes/terraform-libvirt-network?ref=v0.1"

  name         = "mynet"
  mode         = "nat"
  cidr         = "192.168.100.0/24"
  dhcp_enabled = true
}
```

### Isolated network (static IPs, no DHCP)

```hcl
module "net" {
  source = "github.com/arndes/terraform-libvirt-network?ref=v0.1"

  name         = "private"
  mode         = "isolated"
  cidr         = "10.0.2.0/24"
  dhcp_enabled = false
}
```

### Bridge network

```hcl
module "net" {
  source = "github.com/arndes/terraform-libvirt-network?ref=v0.1"

  name   = "bridged"
  mode   = "bridge"
  bridge = "br0"
  cidr   = "192.168.1.0/24"
}
```

## CIDR math

The module derives all addresses from `cidr` using `cidrhost()`:

| Local | Offset | Example (`192.168.100.0/24`) |
|-------|--------|------------------------------|
| `gateway` | `.1` | `192.168.100.1` |
| `dhcp_start` | `.2` | `192.168.100.2` |
| `dhcp_end` | `.-2` (last usable host) | `192.168.100.254` |

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `name` | `string` | — | Name of the libvirt network. |
| `mode` | `string` | `"nat"` | Network mode: `nat`, `isolated`, or `bridge`. |
| `cidr` | `string` | — | CIDR block, e.g. `"192.168.100.0/24"`. |
| `dhcp_enabled` | `bool` | `true` | Enable DHCP on the network. |
| `bridge` | `string` | `""` | Host bridge device name. Required when `mode = "bridge"`. |
| `domain` | `string` | `""` | Optional DNS domain associated with the network. |
| `autostart` | `bool` | `true` | Auto-start the network when the host boots. |

## Outputs

| Name | Description |
|------|-------------|
| `network_name` | Name of the created libvirt network. |
| `network_id` | ID (URI) of the created libvirt network. |
| `gateway` | Gateway address (first host in the CIDR block). |

## Requirements

| Provider | Version |
|----------|---------|
| `dmacvicar/libvirt` | `>= 0.7` |
