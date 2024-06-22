resource "aws_dynamodb_table" "vp_dynamodb" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "userId"
    type = "S"
  }

  attribute {
    name = "paymentId"
    type = "S"
  }

  attribute {
    name = "stepId"
    type = "N"
  }
  attribute {
    name = "status"
    type = "S"
  }
  attribute {
    name = "amount"
    type = "N"
  }

  attribute {
    name = "isPrimary"
    type = "N"
  }
  attribute {
    name = "createAt"
    type = "S"
  }

  attribute {
    name = "lastUpdateAt"
    type = "S"
  }

  hash_key = "paymentId"

  # Global Secondary Index for status
  global_secondary_index {
    name            = "StatusIndex"
    hash_key        = "status"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "StepIdIndex"
    hash_key        = "stepId"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "AmountIndex"
    hash_key        = "amount"
    projection_type = "ALL"
  }

  global_secondary_index {
    name            = "UserIdIndex"
    hash_key        = "userId"
    projection_type = "ALL"
  }
  global_secondary_index {
    name            = "IsPrimaryIndex"
    hash_key        = "isPrimary"
    projection_type = "ALL"
  }

  # Global Secondary Index for create_at
  global_secondary_index {
    name            = "CreateAtIndex"
    hash_key        = "createAt"
    projection_type = "ALL"
  }

  # Global Secondary Index for last_update_at
  global_secondary_index {
    name            = "LastUpdateAtIndex"
    hash_key        = "lastUpdateAt"
    projection_type = "ALL"
  }

  tags = {
    Environment = "production"
    Name        = var.dynamodb_table_name
  }
}
