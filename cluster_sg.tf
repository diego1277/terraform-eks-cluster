resource "aws_security_group_rule" "cluster_rule_node" {
  source_security_group_id = module.node_sg.id
  from_port   = 0
  to_port     = 0
  description = "allow node"
  protocol    = -1
  security_group_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
  type              = "ingress"
}
