output "endpoint" {
  description = "cluster endpoint"
  value = aws_eks_cluster.this.endpoint
}

output "cert" {
  description = "cluster certificate"
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "name" {
  description = "cluster name"
  value = aws_eks_cluster.this.name
}

output "openid_connect_url" {
  description = "openid connect url"
  value = local.openid_connect_url
}

output "openid_connect_arn" {
  description = "openid connect arn"
  value = try(aws_iam_openid_connect_provider.this[0].arn,null)
}

output "security_group_id" {
  description = "eks security groups id"
  value   = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}
