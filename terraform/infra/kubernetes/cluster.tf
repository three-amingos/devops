module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.20"
  subnets         = module.vpc.private_subnets

  tags = var.tags

  vpc_id = module.vpc.vpc_id

  node_groups_defaults = {
    disk_size = 8
    iam_role_arn = aws_iam_role.nodes_role.arn
  }

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity = 2
      min_capacity = 1
      instance_types = [
        var.instance_type
      ]
      capacity_type = "SPOT"
      k8s_labels = var.tags
    }
  }
}



