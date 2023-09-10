# Create a new load balancer
resource "aws_elb" "ELB-01" {
  name               = "elb-01"
  subnets = [aws_subnet.pub-sb-01.id, aws_subnet.pub-sb-02.id]
  security_groups = [aws_security_group.ELB-SG.id]


  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 80
    lb_protocol        = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "elb-01"
  }
}
# Security group for AWS ELB
resource "aws_security_group" "ELB-SG" {
  name        = "elb-sg"
  description = "Security group for AWS ELB"
  vpc_id      = aws_vpc.vpc-01.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.vpc-01.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "elb-sg"
  }
}

# Security group for instances
resource "aws_security_group" "EC2-SG" {
  name        = "elb-ec2"
  description = "Security group for instances"
  vpc_id      = aws_vpc.vpc-01.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

	ingress {
	    from_port        = 80
	    to_port          = 80
	    protocol         = "tcp"
	    security_groups      = [aws_security_group.ELB-SG.id]
	  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg"
  }
}