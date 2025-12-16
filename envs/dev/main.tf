locals {
  environment = "dev"

  clusters = {
    default = {
      cluster_name = "dev-eks"
    }
  }
}

module "vpc" {
  source = "../../modules/vpc"

  cluster_name       = local.environment
  vpc_cidr           = var.vpc_cidr
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  azs                = var.azs
  enable_nat_gateway = var.enable_nat_gateway

  tags = {
    Environment = local.environment
  }
}

module "eks" {
  for_each = local.clusters
  source   = "../../modules/eks"

  cluster_name    = each.value.cluster_name
  cluster_version = var.eks_cluster_version

  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids

  instance_types = var.eks_node_instance_types
  capacity_type  = var.eks_capacity_type

  desired_size = var.eks_node_desired_size[local.environment]
  min_size     = var.eks_node_min_size[local.environment]
  max_size     = var.eks_node_max_size[local.environment]

  tags = {
    Environment = local.environment
  }
}

