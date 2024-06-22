output "my_event_bus_arn" {
  value = aws_cloudwatch_event_bus.my_event_bus.arn
}

output "sqs_queue_arn" {
  value = aws_sqs_queue.vp_queue.arn
}
