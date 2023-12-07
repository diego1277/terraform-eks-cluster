variable "name" {
  description = "cluster name"
  type        = string
}

variable "cluster_version" {
  description = "kubernetes version"
  type        = string
  default     = "1.27"
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}

variable "subnets_id" {
  description = "subnets id"
  type        = list(string)
}

variable "enable_openid_connect" {
  type        = bool
  default     = false
  description = "enable openid connect provider"
}

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

variable "enable_karpenter" {
  description = "define se karpenter esta habilitado"
  type        = bool
  default     = true
}
