variable "name" {
  type        = string
  description = "Name of the libvirt network."
}

variable "mode" {
  type        = string
  default     = "nat"
  description = "Network mode: nat, isolated, or bridge."

  validation {
    condition     = contains(["nat", "isolated", "bridge"], var.mode)
    error_message = "mode must be one of: nat, isolated, bridge."
  }
}

variable "cidr" {
  type        = string
  description = "CIDR block for the network, e.g. \"192.168.100.0/24\"."
}

variable "dhcp_enabled" {
  type        = bool
  default     = true
  description = "Enable DHCP on the network."
}

variable "domain" {
  type        = string
  default     = ""
  description = "Optional DNS domain associated with the network."
}

# Only relevant when mode = "bridge".
variable "bridge" {
  type        = string
  default     = ""
  description = "Host bridge device name (required when mode = \"bridge\")."
}

variable "autostart" {
  type        = bool
  default     = true
  description = "Auto-start the network when the host boots."
}
