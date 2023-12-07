module "node_sg" {
  source = "github.com/diego1277/terraform-module-sg.git"
  name = "${aws_eks_cluster.this.name}_node_sg"
  description = "${aws_eks_cluster.this.name} node sg"
  vpc_id = var.vpc_id  
  ingress_rules = {
     ingress_self = {
        description = "ingress self"
        protocol  = -1
        self      = true
        from_port = 0
        to_port   = 0
      }
     cluster_allow  = {
        description = "ingress cluster ${aws_eks_cluster.this.name}"
        protocol  = -1
        security_groups = [aws_eks_cluster.this.vpc_config[0].cluster_security_group_id]
        from_port = 0
        to_port   = 0
      }
  }
  additional_tags = {
    "karpenter.sh/discovery/${aws_eks_cluster.this.name}" = aws_eks_cluster.this.name
  }
}
