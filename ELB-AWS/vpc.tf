# Create AWS VPC
resource "aws_vpc" "vpc-01" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  /* enable_classicLink = "false" */

  tags = {
    Name = "vpc-01"
  }
}

#-------------------------------------------PUBLIC SUBNETS-----------------------------------------------
resource "aws_subnet" "pub-sb-01" {
  vpc_id     = aws_vpc.vpc-01.id
  cidr_block = "10.0.1.0/24"
  availability_zone  = "us-east-2a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "pub-sb-01"
  }
}

resource "aws_subnet" "pub-sb-02" {
  vpc_id     = aws_vpc.vpc-01.id
  cidr_block = "10.0.2.0/24"
  availability_zone  = "us-east-2b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "pub-sb-02"
  }
}

resource "aws_subnet" "pub-sb-03" {
  vpc_id     = aws_vpc.vpc-01.id
  cidr_block = "10.0.3.0/24"
  availability_zone  = "us-east-2c"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "pub-sb-03"
  }
}

#-------------------------------------------------------------------------------------------------------------


#-------------------------------------------PRIVATE SUBNETS-----------------------------------------------
resource "aws_subnet" "priv-sb-01" {
  vpc_id     = aws_vpc.vpc-01.id
  cidr_block = "10.0.4.0/24"
  availability_zone  = "us-east-2a"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "priv-sb-01"
  }
}

resource "aws_subnet" "priv-sb-02" {
  vpc_id     = aws_vpc.vpc-01.id
  cidr_block = "10.0.5.0/24"
  availability_zone  = "us-east-2b"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "priv-sb-02"
  }
}

resource "aws_subnet" "priv-sb-03" {
  vpc_id     = aws_vpc.vpc-01.id
  cidr_block = "10.0.6.0/24"
  availability_zone  = "us-east-2c"
  map_public_ip_on_launch = "false"

  tags = {
    Name = "priv-sb-03"
  }
}

#-------------------------------------------------------------------------------------------------------------


# Custom internet Gateway
resource "aws_internet_gateway" "int-gw-01" {
  vpc_id = aws_vpc.vpc-01.id

  tags = {
    Name = "int-gw-01"
  }
}


# Routing table for the custom VPC
resource "aws_route_table" "pub-rt-01" {
  vpc_id = aws_vpc.vpc-01.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.int-gw-01.id
  }

  tags = {
    Name = "pub-rt-01"
  }
}

# Link public subnet to route table
resource "aws_route_table_association" "pub-association-01" {
  subnet_id      = aws_subnet.pub-sb-01.id
  route_table_id = aws_route_table.pub-rt-01.id
}
resource "aws_route_table_association" "pub-association-02" {
  subnet_id      = aws_subnet.pub-sb-02.id
  route_table_id = aws_route_table.pub-rt-01.id
}
resource "aws_route_table_association" "pub-association-03" {
  subnet_id      = aws_subnet.pub-sb-03.id
  route_table_id = aws_route_table.pub-rt-01.id
}