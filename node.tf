resource "aws_eks_node_group" "node" {
  for_each        = length(var.node_group) > 0 ? var.node_group : {}
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = each.value.name
  node_role_arn   = aws_iam_role.node.arn
  capacity_type   = each.value.capacity_type
  instance_types  = each.value.instance_types
  version         = var.cluster_version
  subnet_ids      = each.value.subnet_ids

  remote_access {
    ec2_ssh_key = aws_key_pair.node[each.key].id
  }

  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  dynamic "taint" {
    for_each = length(try(each.value.taints, {})) > 0 ? each.value.taints : {}
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_AmazonEC2ContainerRegistryReadOnly,
  ]
  tags = merge(local.node_common_tags, try(each.value.tags, {}))
}

resource "aws_key_pair" "node" {
  for_each   = length(var.node_group) > 0 ? var.node_group : {}
  key_name   = "${each.value.name}_key"
  public_key = tls_private_key.node_rsa[each.key].public_key_openssh
}

resource "tls_private_key" "node_rsa" {
  for_each  = length(var.node_group) > 0 ? var.node_group : {}
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "node_rsa_private_key" {
  for_each = length(var.node_group) > 0 ? var.node_group : {}
  content  = tls_private_key.node_rsa[each.key].private_key_openssh
  filename = "${path.root}/${each.value.name}.pem"
}
