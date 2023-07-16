data "aws_sns_topic" "lambda_message" {
    name = "lambda_message"
}

resource "aws_sns_topic" "lambda_message" {
    name = "lambda_message"
  
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
    protocol = "email"
    endpoint = var.my_email
    topic_arn =data.aws_sns_topic.lambda_message.arn

}