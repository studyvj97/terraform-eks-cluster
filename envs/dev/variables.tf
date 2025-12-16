variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "Private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "enable_nat_gateway" {
  description = "Enable NAT Gateway?"
  type        = bool
  default     = true
}

variable "eks_cluster_version" {
  description = "EKS Kubernetes version"
  type        = string
  default     = "1.34"
}

variable "eks_node_desired_size" {
  description = "Desired node count per environment"
  type        = map(number)
  default = {
    dev   = 2
    stage = 2
    prod  = 3
  }
}

variable "eks_node_min_size" {
  description = "Min node count per environment"
  type        = map(number)
  default = {
    dev   = 1
    stage = 1
    prod  = 2
  }
}

variable "eks_node_max_size" {
  description = "Max node count per environment"
  type        = map(number)
  default = {
    dev   = 3
    stage = 4
    prod  = 6
  }
}

variable "eks_node_instance_types" {
  description = "Instance types for EKS managed node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "eks_capacity_type" {
  description = "Capacity type: ON_DEMAND or SPOT"
  type        = string
  default     = "ON_DEMAND"
}
variable "azs" {
  description = "AZs for subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
