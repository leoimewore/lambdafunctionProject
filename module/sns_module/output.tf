output "arn" {
    value = data.aws_sns_topic.lambda_message.arn
}