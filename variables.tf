<<<<<<< HEAD
variable "name" {
=======
variable name {
>>>>>>> 9c0f6899b164383425dc29d692f201b5ca1f8330
  description = "cluster name"
  type        = string
}

<<<<<<< HEAD
variable "cluster_version" {
  description = "kubernetes version"
  type        = string
  default     = "1.27"
}

variable "vpc_id" {
=======
variable cluster_version {
  description = "kubernetes version"
  type        = string
  default = "1.24"
}

variable vpc_id {
>>>>>>> 9c0f6899b164383425dc29d692f201b5ca1f8330
  description = "vpc id"
  type        = string
}

<<<<<<< HEAD
variable "subnets_id" {
=======
variable subnets_id {
>>>>>>> 9c0f6899b164383425dc29d692f201b5ca1f8330
  description = "subnets id"
  type        = list(string)
}

<<<<<<< HEAD
variable "enable_openid_connect" {
=======
variable additional_tags {
  description = "additional tags"
  type = map(any)
  default = {}
}

variable enable_openid_connect {
>>>>>>> 9c0f6899b164383425dc29d692f201b5ca1f8330
  type        = bool
  default     = false
  description = "enable openid connect provider"
}
<<<<<<< HEAD

variable "ssh_key_name" {
  description = "ssh key name"
  type        = string
  default     = ""
}

variable "generate_key_pair" {
  description = "auto generate ssh key pair"
  type        = bool
  default     = true
}

variable "additional_tags" {
  description = "additional tags"
  type        = map(any)
  default     = {}
}

variable "node_group" {
  description = "node group configuration"
  type        = map(any)
  default     = {}
}

variable "custom_node_group" {
  description = "node group configuration"
  type        = map(any)
  default     = {}
}
=======
>>>>>>> 9c0f6899b164383425dc29d692f201b5ca1f8330
