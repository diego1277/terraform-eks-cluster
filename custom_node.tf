resource "aws_launch_template" "custom_node" {
  for_each = length(var.custom_node_group) > 0 ? var.custom_node_group : {}
  name     = "${each.value.name}_launch_template"

  #vpc_security_group_ids = concat(each.value.security_group_ids,[aws_eks_cluster.this.vpc_config[0].cluster_security_group_id])

  network_interfaces {
     security_groups = concat(each.value.security_group_ids,[aws_eks_cluster.this.vpc_config[0].cluster_security_group_id])
   }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = each.value.volume_size
      volume_type = each.value.volume_type
    }
  }

  image_id = each.value.image_id

  instance_type = each.value.instance_type

  user_data = base64encode(<<-EOF
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="
--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
/etc/eks/bootstrap.sh ${var.name}
--==MYBOUNDARY==--\
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.node_common_tags, try(each.value.tags, {}))
  }
}

resource "aws_eks_node_group" "custom_node" {
  for_each        = length(var.custom_node_group) > 0 ? var.custom_node_group : {}
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${each.value.name}_custom"
  node_role_arn   = aws_iam_role.node.arn
  capacity_type   = each.value.capacity_type
  #instance_types  = each.value.instance_types
  #version         = var.cluster_version
  subnet_ids      = each.value.subnet_ids

  launch_template {
    name    = aws_launch_template.custom_node[each.key].name
    version = aws_launch_template.custom_node[each.key].latest_version
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

  lifecycle {
    create_before_destroy = true
  }

}

/*
resource "aws_key_pair" "custom_node" {
  for_each   = length(var.custom_node_group) > 0 ? var.custom_node_group : {}
  key_name   = "${each.value.name}_custom_node_key"
  public_key = tls_private_key.custom_node_rsa[each.key].public_key_openssh
}

resource "tls_private_key" "custom_node_rsa" {
  for_each  = length(var.custom_node_group) > 0 ? var.custom_node_group : {}
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "custom_node_rsa_private_key" {
  for_each = length(var.custom_node_group) > 0 ? var.custom_node_group : {}
  content  = tls_private_key.custom_node_rsa[each.key].private_key_openssh
  filename = "${path.root}/${each.value.name}_custom_node.pem"
}
*/
