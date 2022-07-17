

resource "aws_launch_template" "devops-test-app-queue-worker-launch-template" {
  instance_type = var.queue_worker_instance_type
  image_id      = var.queue_worker_ami_id
  monitoring {
    enabled = true
  }
  network_interfaces {
    associate_public_ip_address = false
    subnet_id                   = aws_subnet.devops-test-app-private-subnet.id
    security_groups = [
      aws_security_group.devops-test-queue-worker-security-group.id,
    ]
  }

  tags = {
    "Name"        = "devops-test-${var.environment_prefix}-queue-worker"
    "Environment" = "${var.environment}"
  }

}

resource "aws_autoscaling_group" "devops-test-queue-worker-autoscaling-group" {
  capacity_rebalance = true
  desired_capacity   = 1
  max_size           = 100
  min_size           = 0
  name               = "${var.environment_prefix}-queue-worker-autoscaling-group"
  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 25
      spot_allocation_strategy                 = "capacity-optimized"
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.devops-test-app-queue-worker-launch-template.id
      }
    }
  }
}


resource "aws_autoscaling_policy" "devops-test-queue-worker-scaling-up-policy" {
  name                   = "${var.environment_prefix}-queue-worker-scaling-up-policy"
  scaling_adjustment     = 3
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 100
  autoscaling_group_name = aws_autoscaling_group.devops-test-queue-worker-autoscaling-group.name
}

resource "aws_autoscaling_policy" "devops-test-queue-worker-scaling-down-policy" {
  name                   = "${var.environment_prefix}-queue-worker-scaling-down-policy"
  scaling_adjustment     = -3
  policy_type            = "SimpleScaling"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 100
  autoscaling_group_name = aws_autoscaling_group.devops-test-queue-worker-autoscaling-group.name
}
resource "aws_security_group" "devops-test-queue-worker-security-group" {
  vpc_id      = aws_vpc.devops-test-app-vpc.id
  description = "queue worker security group"

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      var.vpc_cibr_block,
    ]
  }

  tags = {
    "Name"        = "devops-test-${var.environment_prefix}-web-queue-worker-security-group"
    "Environment" = "${var.environment}"
  }
}
