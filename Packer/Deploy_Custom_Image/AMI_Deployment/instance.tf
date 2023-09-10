# Create Instance uisng Custom VPC

module "VPC-01-DEV" {
  source = "../modules/vpc"

  ENVIRONMENT = var.ENV
  AWS_REGION = var.AWS_REGION
}

provider "aws" {
  
  region = var.AWS_REGION

}

#Resource key pair
resource "aws_key_pair" "levelup_key" {
  key_name      = "levelup_key"
  public_key    = file(var.KEY_PUB_PATH)
}

#Security Group for Instances
resource "aws_security_group" "SEC-GRP-SSH" {
  vpc_id      = module.VPC-01-DEV.VPC-ID
  name        = "allow-ssh-${var.ENV}"
  description = "security group that allows ssh traffic"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name         = "allow-ssh"
    Environmnent = var.ENV
  }
}

# Create Instance Group
resource "aws_instance" "EC2-01" {
  ami           = var.AMI_ID
  instance_type = var.INSTANCE_TYPE

  # the VPC subnet
  subnet_id = element(module.VPC-01-DEV.PUBLIC_SUBNETS, 0)
  availability_zone = "${var.AWS_REGION}a"

  # the security group
  vpc_security_group_ids = ["${aws_security_group.SEC-GRP-SSH.id}"]

  # the public SSH key
  key_name = aws_key_pair.levelup_key.key_name

  # attribuer une adresse IP publique à l'instance
  associate_public_ip_address = true

  tags = {
    Name         = "instance-${var.ENV}"
    Environmnent = var.ENV
  }
}
