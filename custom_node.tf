resource "aws_launch_template" "custom_node" {
  for_each = length(var.custom_node_group) > 0 ? var.custom_node_group : {}
  name     = "${each.value.name}_launch_template"

  network_interfaces {
     security_groups = concat(try(each.value.security_group_ids,[]),[aws_eks_cluster.this.vpc_config[0].cluster_security_group_id,module.node_sg.id])
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
