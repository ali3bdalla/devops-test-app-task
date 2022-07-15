environment                = "development"
environment_prefix         = "dev-"
aws_region                 = "eu-central-1"
vpc_cibr_block             = "10.2.0.0/16"
private-subnet-cidr-block  = "10.2.1.0/24"
public-subnet-cidr-block   = "10.2.2.0/24"
webserver_instance_type    = "t2.micro"
webserver_ami              = "ami-0a1ee2fb28fe05df3"
database_billing_mode      = "PAY_PER_REQUEST"
database_table_name        = "dev-db-table"
queue_worker_instance_type = "t2.micro"
queue_worker_ami_id        = "ami-0a1ee2fb28fe05df3"
