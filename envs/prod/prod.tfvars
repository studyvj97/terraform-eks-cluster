clusters = {
  main = {
    cluster_name = "prod-eks"
  }
}

vpc_cidr        = "10.1.0.0/16"
public_subnets  = ["10.1.1.0/24", "10.1.2.0/24"]
private_subnets = ["10.1.3.0/24", "10.1.4.0/24"]
azs             = ["us-east-1a", "us-east-1b"]

eks_cluster_version = "1.34"

eks_node_desired_size = {
  prod = 3
}

eks_node_min_size = {
  prod = 2
}

eks_node_max_size = {
  prod = 6
}

eks_node_instance_types = ["t3.medium"]
eks_capacity_type       = "ON_DEMAND"
enable_nat_gateway      = true

