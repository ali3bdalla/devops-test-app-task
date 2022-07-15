// global configuration variables
variable "environment" {
  description = "The environment to deploy to"
  default     = "dev"
}

variable "environment_prefix" {
  description = "The environment prefix to use for naming resources"
  default     = "development"
}
variable "aws_region" {
  description = "The AWS region to deploy to"
  default     = "eu-central-1"
}
// networking variables 
variable "vpc_cibr_block" {
  type        = string
  description = "The aws Vpc Cidr Block"
  default     = "10.10.0.0/16"
}
variable "private-subnet-cidr-block" {
  type        = string
  description = "The aws private subnet Cidr Block"
  default     = "10.10.1.0/24"
}
variable "public-subnet-cidr-block" {
  type        = string
  description = "The aws public subnet Cidr Block"
  default     = "10.10.2.0/24"
}


// web server variables
variable "webserver_instance_type" {
  type        = string
  description = "The aws webserver instance type"
  default     = "t2.micro"
}
variable "webserver_ami" {
  type        = string
  description = "The aws webserver ami"
  default     = "ami-0a1ee2fb28fe05df3"
}
// database variables
variable "database_billing_mode" {
  type        = string
  description = "The aws dynamodb billing mode: PROVISIONED | PAY_PER_REQUEST"
  default     = "PAY_PER_REQUEST"
}

variable "database_table_name" {
  type        = string
  description = "The aws database table name"
  default     = "devops-test-app-database-table"
}

// queue worker server variables
variable "queue_worker_instance_type" {
  type        = string
  description = "The aws queue worker instance type"
  default     = "c5.large"
}
variable "queue_worker_ami_id" {
  type        = string
  description = "The aws queue ami"
  default     = "ami-0a1ee2fb28fe05df3"
}


