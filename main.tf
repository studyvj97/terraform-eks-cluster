module "vpc" {
  source = "./modules/vpc"

  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  enable_nat_gateway = var.enable_nat_gateway
  azs                = var.azs
  tags         = local.common_tags
  cluster_name = "${local.environment}-eks"
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = "${local.environment}-eks"
  cluster_version = var.eks_cluster_version

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  desired_size = lookup(var.eks_node_desired_size, local.environment, 2)
  min_size     = lookup(var.eks_node_min_size, local.environment, 1)
  max_size     = lookup(var.eks_node_max_size, local.environment, 4)

  instance_types = var.eks_node_instance_types
  capacity_type  = var.eks_capacity_type

  tags = local.common_tags

  depends_on = [module.vpc]
}

