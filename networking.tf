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

resource "aws_route_table_association" "devops-test-frontend-route-table-association" {
  subnet_id      = aws_subnet.devops-test-app-private-subnet.id
  route_table_id = aws_route_table.devops-test-app-private-route-table.id
}

resource "aws_route_table_association" "devops-test-backend-route-table-association" {
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


