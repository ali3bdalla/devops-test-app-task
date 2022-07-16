resource "aws_cloudwatch_dashboard" "devops-test-app-cloud-watch-dashboard" {
  dashboard_name = "devops-test-${var.environment_prefix}-cloud-watch-dashboard"
  dashboard_body = <<EOF
{
    "widgets": [
        {
            "height": 9,
            "width": 23,
            "y": 0,
            "x": 0,
            "type": "explorer",
            "properties": {
                "metrics": [
                    {
                        "metricName": "CPUUtilization",
                        "resourceType": "AWS::EC2::Instance",
                        "stat": "Average"
                    }
                ],
                "aggregateBy": {
                    "key": "*",
                    "func": "MAX"
                },
                "labels": [
                    {
                        "key": "AvailabilityZone"
                    }
                ],
                "widgetOptions": {
                    "legend": {
                        "position": "bottom"
                    },
                    "view": "timeSeries",
                    "stacked": false,
                    "rowsPerPage": 1,
                    "widgetsPerRow": 1
                },
                "period": 300,
                "splitBy": "",
                "region": "${var.aws_region}",
                "title": "Explorer"
            }
        },
        {
            "height": 12,
            "width": 13,
            "y": 9,
            "x": 10,
            "type": "metric",
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/DynamoDB", "ConsumedReadCapacityUnits", "TableName", "${var.database_table_name}" ],
                    [ ".", "ConsumedWriteCapacityUnits", ".", "." ]
                ],
                "region": "${var.aws_region}"
            }
        },
        {
            "height": 12,
            "width": 10,
            "y": 9,
            "x": 0,
            "type": "metric",
            "properties": {
                "sparkline": true,
                "view": "singleValue",
                "metrics": [
                    [ { "expression": "SELECT COUNT(NumberOfMessagesReceived) FROM SCHEMA(\"AWS/SQS\", QueueName)", "label": "Query1", "id": "q1" } ]
                ],
                "region": "${var.aws_region}",
                "stat": "Average",
                "period": 300
            }
        }
    ]
}
EOF
}
