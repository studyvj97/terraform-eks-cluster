variable "vpc_cidr" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {}
}

variable "cluster_name" {
  description = "EKS cluster name (for subnet tags)"
  type        = string
}
variable "azs" {
  description = "List of availability zones to use"
  type        = list(string)
}
