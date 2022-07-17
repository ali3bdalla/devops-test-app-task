resource "aws_vpc" "devops-test-app-vpc" {
  cidr_block = var.vpc_cibr_block
  tags = {
    "Name"        = "devops-test-${var.environment_prefix}-vpc"
    "Environment" = "${var.environment}"
  }
}
resource "aws_internet_gateway" "devops-test-app-igw" {
  vpc_id = aws_vpc.devops-test-app-vpc.id
  tags = {
    "Name"        = "devops-test-${var.environment_prefix}-igw"
    "Environment" = "${var.environment}"
  }
}


resource "aws_eip" "devops-test-app-nat-eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.devops-test-app-igw]
  tags = {
    "Name"        = "devops-test-${var.environment_prefix}-nat-eip"
    "Environment" = "${var.environment}"
  }
}

resource "aws_nat_gateway" "devops-test-app-nat-gateway" {
  allocation_id = aws_eip.devops-test-app-nat-eip.id
  subnet_id     = aws_subnet.devops-test-app-public-subnet.id
  tags = {
    "Name"        = "devops-test-${var.environment_prefix}-nat-gateway"
    "Environment" = "${var.environment}"
  }
}

resource "aws_subnet" "devops-test-app-public-subnet" {
  vpc_id                  = aws_vpc.devops-test-app-vpc.id
  cidr_block              = var.public-subnet-cidr-block
  map_public_ip_on_launch = true
  tags = {
    "Name"        = "devops-test-${var.environment_prefix}-public-subnet"
    "Environment" = "${var.environment}"
  }
}
resource "aws_subnet" "devops-test-app-private-subnet" {
  vpc_id                  = aws_vpc.devops-test-app-vpc.id
  cidr_block              = var.private-subnet-cidr-block
  map_public_ip_on_launch = false
  tags = {
    "Name"        = "devops-test-${var.environment_prefix}-private-subnet"
    "Environment" = "${var.environment}"
  }
}



resource "aws_route_table" "devops-test-app-public-route-table" {
  vpc_id = aws_vpc.devops-test-app-vpc.id
  tags = {
    "Name"        = "devops-test-${var.environment_prefix}-public-route-table"
    "Environment" = "${var.environment}"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.devops-test-app-igw.id
  }
}

resource "aws_route_table_association" "devops-test-public-route-table-association" {
  subnet_id      = aws_subnet.devops-test-app-private-subnet.id
  route_table_id = aws_route_table.devops-test-app-private-route-table.id
}

resource "aws_route_table_association" "devops-test-private-route-table-association" {
  subnet_id      = aws_subnet.devops-test-app-public-subnet.id
  route_table_id = aws_route_table.devops-test-app-public-route-table.id
}




resource "aws_route_table" "devops-test-app-private-route-table" {
  vpc_id = aws_vpc.devops-test-app-vpc.id
  tags = {
    "Name"        = "devops-test-${var.environment_prefix}-backend-rt"
    "Environment" = "${var.environment}"
  }

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.devops-test-app-nat-gateway.id
  }
}


# resource "aws_security_group" "devops-test-app-lb-security-group" {
#   vpc_id = aws_vpc.devops-test-app-vpc.id
#   tags = {
#     "Name"        = "devops-test-${var.environment_prefix}-lb-security-group"
#     "Environment" = "${var.environment}"
#   }

#   ingress {
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     from_port   = 80
#     to_port     = 80
#   }

#   ingress {
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     from_port   = 220
#     to_port     = 220
#   }
#   ingress {
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     from_port   = 443
#     to_port     = 443
#   }
#   ingress {
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     from_port   = 1220
#     to_port     = 1220
#   }
# }

# resource "aws_network_acl" "devops-test-app-public-network-acl" {
#   vpc_id = aws_vpc.devops-test-app-vpc.id
#   tags = {
#     "Name"        = "devops-test-${var.environment_prefix}-public-network-acl"
#     "Environment" = "${var.environment}"
#   }



#   egress {
#     rule_no    = 100
#     protocol   = "-1"
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 0
#     to_port    = 0
#   }
#   ingress {
#     rule_no    = 200
#     protocol   = "-1"
#     action     = "allow"
#     cidr_block = var.vpc_cibr_block
#     from_port  = 0
#     to_port    = 0
#   }
#   ingress {
#     rule_no    = 300
#     protocol   = "tcp"
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 80
#     to_port    = 80
#   }

#   ingress {
#     rule_no    = 400
#     protocol   = "tcp"
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 220
#     to_port    = 220
#   }
#   ingress {
#     rule_no    = 500
#     protocol   = "tcp"
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 443
#     to_port    = 443
#   }
#   ingress {
#     rule_no    = 600
#     protocol   = "tcp"
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 1220
#     to_port    = 1220
#   }
# }

# resource "aws_network_acl_association" "devops-test-app-public-network-acl-association" {
#   subnet_id      = aws_subnet.devops-test-app-public-subnet.id
#   network_acl_id = aws_network_acl.devops-test-app-public-network-acl.id
#   depends_on     = [aws_internet_gateway.devops-test-app-igw]
# }


resource "aws_elb" "devops-test-app-elb" {
  name               = "devops-test-${var.environment_prefix}-app-elb"
  availability_zones = [aws_subnet.devops-test-app-public-subnet.availability_zone]
  vpc_id             = aws_vpc.devops-test-app-vpc.id
  subnets = [
    aws_subnet.devops-test-app-public-subnet.id,
  ]
  access_logs {
    bucket        = "foo"
    bucket_prefix = "bar"
    interval      = 60
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 443
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/devops-test-app-elb-cert"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    "Name"        = "devops-test-${var.environment_prefix}-app-elb"
    "Environment" = "${var.environment}"
  }
}


