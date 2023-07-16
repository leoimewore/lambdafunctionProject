output fname {
    value=aws_lambda_function.notify_function.function_name
}

output "invoke_arn" {
    value = aws_lambda_function.notify_function.invoke_arn
  
}