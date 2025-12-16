clusters = {
  app = {
    cluster_name = "dev-app-eks"
  }
  ops = {
    cluster_name = "dev-ops-eks"
  }
}


vpc_cidr        = "10.0.0.0/16"
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
azs             = ["us-east-1a", "us-east-1b"]

eks_cluster_version = "1.34"

eks_node_desired_size = {
  dev = 2
}

eks_node_min_size = {
  dev = 1
}

eks_node_max_size = {
  dev = 3
}

eks_node_instance_types = ["t3.medium"]
eks_capacity_type       = "ON_DEMAND"
enable_nat_gateway      = true

