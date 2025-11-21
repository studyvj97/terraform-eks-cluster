resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = "${var.tags["Environment"]}-vpc"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.tags["Environment"]}-igw"
  })
}

# Public Subnets
resource "aws_subnet" "public" {
  for_each = {
    for i, cidr in var.public_subnets :
    i => {
      cidr = cidr
      az   = var.azs[i]
    }
  }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name                                      = "${var.tags["Environment"]}-public-${each.key}"
    Tier                                      = "public"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  })
}

# Private Subnets
resource "aws_subnet" "private" {
   for_each = {
    for i, cidr in var.private_subnets :
    i => {
      cidr = cidr
      az   = var.azs[i]
    }
  }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = merge(var.tags, {
    Name                                      = "${var.tags["Environment"]}-private-${each.key}"
    Tier                                      = "private"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"          = "1"
  })
}

# NAT Gateway (optional)
resource "aws_eip" "nat_eip" {
  count  = var.enable_nat_gateway ? 1 : 0
  domain = "vpc"                           # <- correct for AWS provider v5

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "natgw" {
  count         = var.enable_nat_gateway ? 1 : 0
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = values(aws_subnet.public)[0].id

  depends_on = [aws_internet_gateway.igw]
}

# Route Tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.tags["Environment"]}-public-rt"
  })
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  count  = var.enable_nat_gateway ? 1 : 0
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, {
    Name = "${var.tags["Environment"]}-private-rt"
  })
}

resource "aws_route" "private_route" {
  count = var.enable_nat_gateway ? 1 : 0

  route_table_id         = aws_route_table.private_rt[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw[0].id

  depends_on = [aws_nat_gateway.natgw]
}

resource "aws_route_table_association" "private_assoc" {
  for_each = var.enable_nat_gateway ? aws_subnet.private : {}

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt[0].id
}

