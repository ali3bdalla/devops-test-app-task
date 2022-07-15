resource "aws_sqs_queue" "devops-test-queuing-system" {
  name = "${var.environment_prefix}-devops-test-queuing-system"
  tags = {
    "Name"        = "devops-test-${var.environment_prefix}-queuing-system"
    "Environment" = "${var.environment}"
  }

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "arn:aws:sqs:*:*:${var.environment_prefix}devops-test-queuing-system",
      "Condition": {
        "ArnEquals": { "aws:SourceArn": "${aws_s3_bucket.devops-test-app-s3-bucket.arn}" }
      }
    }
  ]
}
POLICY
}

resource "aws_cloudwatch_metric_alarm" "devops-test-app-queue-system-alarm" {
  alarm_name          = "${var.environment_prefix}-devops-test-app-queue-system-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = "60"
  statistic           = "Average"
  threshold           = "5000"
  treat_missing_data  = "notBreaching"

  dimensions = {
    QueueName            = "${aws_sqs_queue.devops-test-queuing-system.name}"
    AutoScalingGroupName = "${aws_autoscaling_group.devops-test-app-webserver-autoscaling-group.name}"
  }

  alarm_description = "This metric monitors queue depth and scales up or down accordingly."
  alarm_actions     = ["${aws_autoscaling_policy.devops-test-queue-worker-scaling-up-policy.arn}"]
  ok_actions        = ["${aws_autoscaling_policy.devops-test-queue-worker-scaling-down-policy.arn}"]
}
