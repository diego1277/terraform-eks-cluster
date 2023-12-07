module "karpenter" {
  source                     = "github.com/diego1277/terraform-kubernetes-addons.git//eks/karpenter"
  count                      = var.enable_karpenter ? 1 : 0
  cluster_name               = aws_eks_cluster.this.name
  cluster_openid_connect_url = local.openid_connect_url
  cluster_openid_connect_arn = aws_iam_openid_connect_provider.this[0].arn
  cluster_endpoint           = aws_eks_cluster.this.endpoint
  instance_profile_name      = aws_iam_instance_profile.this.name
}
