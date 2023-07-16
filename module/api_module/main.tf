

module "lambda" {
    source= "../lambda-module"
}


resource "aws_api_gateway_rest_api" "api" {
    name = "api-gateway"
    description = "Supply post request to the Lambda function"
   
    
}




resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "lambda"
}

resource "aws_api_gateway_method" "api_method" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id  = aws_api_gateway_resource.api_resource.id
  http_method = "POST"
  authorization = "NONE"

  
}

resource "aws_api_gateway_integration" "lambdaIntegration" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id  = aws_api_gateway_resource.api_resource.id
    http_method = aws_api_gateway_method.api_method.http_method
    type = "AWS_PROXY"
    uri = module.lambda.invoke_arn
    content_handling = "CONVERT_TO_TEXT"
    integration_http_method = "POST"

    
    
  
}
resource "aws_api_gateway_method_response" "response_200" {
 rest_api_id = aws_api_gateway_rest_api.api.id
 resource_id  = aws_api_gateway_resource.api_resource.id
 http_method = aws_api_gateway_method.api_method.http_method
 status_code = "200"


}

resource aws_api_gateway_integration_response "api_integration_response" {
    rest_api_id = aws_api_gateway_rest_api.api.id
    resource_id  = aws_api_gateway_resource.api_resource.id
    http_method = aws_api_gateway_method.api_method.http_method
    status_code = aws_api_gateway_method_response.response_200.status_code
#     content_handling = "CONVERT_TO_TEXT"



}


resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.fname
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}


resource "aws_api_gateway_deployment" "dev" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.api_resource.id,
      aws_api_gateway_method.api_method.id,
      aws_api_gateway_integration.lambdaIntegration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.dev.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "dev"

  
}


