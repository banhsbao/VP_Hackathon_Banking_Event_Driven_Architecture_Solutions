resource "aws_cloudwatch_event_bus" "my_event_bus" {
  name = "my-event-bus"
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = var.payment_notification_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_bus.my_event_bus.arn
}

resource "aws_cloudwatch_event_rule" "my_event_rule" {
  name           = "create-new-payment"
  event_bus_name = aws_cloudwatch_event_bus.my_event_bus.name
  event_pattern = jsonencode({
    "source" : ["my-event-bus"],
    "detail-type" : ["create_payment_event"]
  })
}

resource "aws_cloudwatch_event_rule" "trigger_notification_rule" {
  name           = "process-payment"
  event_bus_name = aws_cloudwatch_event_bus.my_event_bus.name
  event_pattern = jsonencode({
    "source" : ["my-event-bus"],
    "detail-type" : ["payment_processed_event"]
  })
}

resource "aws_cloudwatch_event_target" "send_to_notification_lambda" {
  rule           = aws_cloudwatch_event_rule.trigger_notification_rule.name
  arn            = var.payment_notification_function_arn
  event_bus_name = aws_cloudwatch_event_bus.my_event_bus.name
}

resource "aws_sqs_queue" "vp_queue" {
  name                       = "create_payment_event_queue"
  visibility_timeout_seconds = 120
}

resource "aws_cloudwatch_event_target" "send_to_sqs" {
  rule           = aws_cloudwatch_event_rule.my_event_rule.name
  arn            = aws_sqs_queue.vp_queue.arn
  event_bus_name = aws_cloudwatch_event_bus.my_event_bus.name
}

resource "aws_sqs_queue_policy" "allow_eventbridge" {
  queue_url = aws_sqs_queue.vp_queue.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "events.amazonaws.com"
        },
        Action   = "sqs:SendMessage",
        Resource = aws_sqs_queue.vp_queue.arn,
        Condition = {
          ArnEquals = {
            "aws:SourceArn" : aws_cloudwatch_event_rule.my_event_rule.arn
          }
        }
      }
    ]
  })
  depends_on = [
    aws_cloudwatch_event_rule.my_event_rule,
    aws_cloudwatch_event_target.send_to_sqs
  ]
}
