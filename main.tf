terraform {
  required_providers {

    aws = {
    source="hashicorp/aws"

    }

  }
}




provider aws {}



module "myrole" {
    source = "./module/roles-module"
  
}

module "message" {
    source = "./module/sns_module"
}

module "lambda" {
    source="./module/lambda-module"
}





resource "aws_lambda_function_event_invoke_config" "example" {
  function_name = module.lambda.fname

  destination_config {
    on_failure {
      destination = module.message.arn
    }

    on_success {
      destination = module.message.arn
    }
  }
}










