
resource "aws_launch_template" "devops-test-app-webserver-launch-template" {
  instance_type = var.webserver_instance_type
  image_id      = var.webserver_ami
  monitoring {
    enabled = true
  }
  user_data = filebase64("${path.module}/helpers/install-nginx.sh")
  network_interfaces {
    associate_public_ip_address = false
    subnet_id                   = aws_subnet.devops-test-app-private-subnet.id
    security_groups = [
      aws_security_group.devops-test-web-server-security-group.id,
    ]
  }

  tags = {
    "Name"        = "devops-test-${var.environment_prefix}-webserver"
    "Environment" = "${var.environment}"
  }

}
resource "aws_autoscaling_policy" "devops-test-app-webserver-scaling-policy" {
  name                   = "${var.environment_prefix}-webserver-scaling-policy"
  scaling_adjustment     = 3
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 100
  autoscaling_group_name = aws_autoscaling_group.devops-test-app-webserver-autoscaling-group.name
}

resource "aws_autoscaling_group" "devops-test-app-webserver-autoscaling-group" {
  availability_zones        = [aws_subnet.devops-test-app-private-subnet.availability_zone]
  name                      = "${var.environment_prefix}-webserver-autoscaling-group"
  desired_capacity          = 1
  max_size                  = 10
  min_size                  = 1
  health_check_grace_period = 100
  health_check_type         = "ELB"
  launch_template {
    id = aws_launch_template.devops-test-app-webserver-launch-template.id
  }
  lifecycle {
    create_before_destroy = true
  }
  force_delete = true
}


resource "aws_security_group" "devops-test-web-server-security-group" {
  vpc_id      = aws_vpc.devops-test-app-vpc.id
  description = "Web server security group"
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      var.vpc_cibr_block,
    ]
  }
  ingress {
    from_port = 1220
    to_port   = 1220
    protocol  = "tcp"
    cidr_blocks = [
      var.vpc_cibr_block,
    ]
  }
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      var.vpc_cibr_block,
    ]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = [
      var.vpc_cibr_block,
    ]
  }
  tags = {
    "Name"        = "devops-test-${var.environment_prefix}-web-server-security-group"
    "Environment" = "${var.environment}"
  }
}
