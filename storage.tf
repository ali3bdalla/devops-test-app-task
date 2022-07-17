

# S3 bucket
resource "aws_s3_bucket" "devops-test-app-s3-bucket" {
  bucket = "${var.environment_prefix}-app-s3-bucket"
  acl    = "private"
  tags = {
    "Name"        = "devops-test-${var.environment_prefix}-s3-bucket"
    "Environment" = "${var.environment}"
  }

}

# resource "aws_s3_bucket_notification" "bucket_notification" {
#   bucket = aws_s3_bucket.devops-test-app-s3-bucket.id
#   queue {
#     queue_arn = aws_sqs_queue.devops-test-queuing-system.arn
#     events    = ["s3:ObjectCreated:*"]
#   }
# }


