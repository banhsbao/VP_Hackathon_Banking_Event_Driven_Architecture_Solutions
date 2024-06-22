resource "aws_sqs_queue" "vp_queue" {
  name = "create_payment_event_queue"
}
