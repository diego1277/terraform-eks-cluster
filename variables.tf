variable name {
  description = "cluster name"
  type        = string
}

variable cluster_version {
  description = "kubernetes version"
  type        = string
  default = "1.24"
}

variable vpc_id {
  description = "vpc id"
  type        = string
}

variable subnets_id {
  description = "subnets id"
  type        = list(string)
}

variable additional_tags {
  description = "additional tags"
  type = map(any)
  default = {}
}

variable enable_openid_connect {
  type        = bool
  default     = false
  description = "enable openid connect provider"
}
