locals {
  openid_connect_url  = try(element(split("oidc-provider/", "${aws_iam_openid_connect_provider.this[0].arn}"), 1), null)
  cluster_common_tags = merge(var.additional_tags, {})
  node_common_tags = merge(var.additional_tags, {
    "k8s.io/cluster-autoscaler/${aws_eks_cluster.this.name}" = "owned",
    "k8s.io/cluster-autoscaler/enabled"                      = "true",
    }
  )
}
