#
# VPC Resources
#  * VPC
#  * Subnets
#  * Internet Gateway
#  * Route Table
#

resource "aws_vpc" "eks" {
  cidr_block = "10.20.0.0/16"

  tags = map(
  "Name", "${var.cluster_name}-vpc",
  "kubernetes.io/cluster/${var.cluster_name}", "shared",
  )
}

resource "aws_subnet" "eks" {
  count = var.az_count

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = "10.20.${count.index}.0/24"
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.eks.id

  tags = map(
  "Name", "${var.cluster_name}-public-subnet",
  "kubernetes.io/cluster/${var.cluster_name}", "shared",
  )
}

resource "aws_internet_gateway" "eks" {
  vpc_id = aws_vpc.eks.id

  tags = {
    Name = "${var.cluster_name}-igw"
  }
}

resource "aws_route_table" "eks" {
  vpc_id = aws_vpc.eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks.id
  }
}

resource "aws_route_table_association" "eks" {
  count = var.az_count

  subnet_id      = aws_subnet.eks.*.id[count.index]
  route_table_id = aws_route_table.eks.id
}
