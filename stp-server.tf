

resource "aws_transfer_server" "devops-test-app-transfer-server" {
  identity_provider_type = "SERVICE_MANAGED"
  endpoint_type          = "VPC"
  endpoint_details {
    subnet_ids = [aws_subnet.devops-test-app-private-subnet.id]
    vpc_id     = aws_vpc.devops-test-app-vpc.id
    security_group_ids = [
      aws_security_group.devops-test-app-transfer-server-sg.id,
    ]
  }
  tags = {
    "Name"        = "devops-test-${var.environment_prefix}-transfer-server"
    "Environment" = "${var.environment}"
  }
}


resource "aws_iam_role" "devops-test-app-transfer-server-iam-role" {
  name = "devops-test-${var.environment_prefix}-transfer-server-iam-role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "transfer.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "devops-test-app-transfer-server-iam-role-policy" {
  name = "devops-test-${var.environment_prefix}-transfer-server-iam-role-policy"
  role = aws_iam_role.devops-test-app-transfer-server-iam-role.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowFullAccesstoS3",
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": "*"
        }
    ]
}
POLICY
}

# resource "aws_transfer_access" "devops-test-app-transfer-access" {
#   external_id    = "S-1-1-12-232353-123456789-1234567890-1234"
#   server_id      = aws_transfer_server.devops-test-app-transfer-server.id
#   role           = aws_iam_role.devops-test-app-transfer-server-iam-role.arn
#   home_directory = "/${aws_s3_bucket.devops-test-app-s3-bucket.id}/"
# }

resource "aws_transfer_user" "devops-test-app-transfer-user" {
  server_id           = aws_transfer_server.devops-test-app-transfer-server.id
  user_name           = "devops-test-${var.environment_prefix}-transfer-user"
  role                = aws_iam_role.devops-test-app-transfer-server-iam-role.arn
  home_directory_type = "LOGICAL"
  home_directory_mappings {
    entry  = "/${aws_s3_bucket.devops-test-app-s3-bucket.id}/devops-test-${var.environment_prefix}-transfer-user"
    target = "/${aws_s3_bucket.devops-test-app-s3-bucket.id}/devops-test-${var.environment_prefix}-transfer-user"
  }
}




resource "aws_security_group" "devops-test-app-transfer-server-sg" {
  vpc_id      = aws_vpc.devops-test-app-vpc.id
  description = "sftp server security group"
  ingress {
    from_port = 22
    to_port   = 22
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
      var.vpc_cibr_block
    ]
  }
  tags = {
    "Name"        = "devops-test-${var.environment_prefix}-transfer-server-sg"
    "Environment" = "${var.environment}"
  }
}
