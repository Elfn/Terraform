# Configuration de lancement pour AutoScaling
resource "aws_launch_configuration" "levelup-launchconfig" {
  name_prefix   = "levelup-launchconfig"
  image_id      = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t3.micro" # J'ai changé le type d'instance de t2.micro à t3.micro
  key_name      = aws_key_pair.levelup_key.key_name
  security_groups = [aws_security_group.ELB-EC2.id]
  user_data       = "#!/bin/bash\napt-get update\napt-get -y install net-tools nginx\nMYIP=`ifconfig | grep -E '(inet 10)|(addr:10)' | awk '{ print $2 }' | cut -d ':' -f2`\necho 'Hello Team\nThis is my IP: '$MYIP > /var/www/html/index.html"


  lifecycle {
    create_before_destroy = true
  }
}

# Générer une clé
resource "aws_key_pair" "levelup_key" {
    key_name   = "levelup_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

# Groupe AutoScaling
resource "aws_autoscaling_group" "levelup-autoscaling" {
  name                      = "levelup-autoscaling"
  vpc_zone_identifier       = [aws_subnet.pub-sb-01.id, aws_subnet.pub-sb-02.id]
  launch_configuration      = aws_launch_configuration.levelup-launchconfig.name
  min_size                  = 2
  max_size                  = 2
  health_check_grace_period = 200
  health_check_type         = "ELB"
  load_balancers            = [aws_elb.ELB-01.name]
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "Instance EC2 via LB"
    propagate_at_launch = true
  }
}

output "ELB" {
  value = aws_elb.ELB-01.dns_name
}