# resource "aws_dynamodb_table" "devops-test-app-dynamodb-table" {
#   name         = var.database_table_name
#   billing_mode = var.database_billing_mode
#   # required in case of Billing mode is PROVISIONED
#   #   read_capacity  = 50
#   #   write_capacity = 50
#   hash_key = "UserId"
#   attribute {
#     name = "UserId"
#     type = "S"
#   }

#   attribute {
#     name = "Visits"
#     type = "N"
#   }
#   attribute {
#     name = "UserName"
#     type = "S"
#   }




#   global_secondary_index {
#     name               = "UserNameIndex"
#     hash_key           = "UserName"
#     range_key          = "Visits"
#     projection_type    = "INCLUDE"
#     non_key_attributes = ["UserId"]
#   }

#   tags = {
#     "Name"        = "devops-test-${var.environment_prefix}-dynamodb-table"
#     "Environment" = "${var.environment}"
#   }
# }
