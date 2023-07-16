

module "myrole" {
    source = "../roles-module"
  
}


data "archive_file" "lambda" {
  type        = "zip"
  source_dir = "./jscode"
  output_path = "./jscode/index.zip"
  
  
}



resource "aws_lambda_function" "notify_function" {
    function_name = "Notify_Function"
    filename = "./jscode/index.zip"
    source_code_hash = data.archive_file.lambda.output_base64sha256
    handler = "index.handler"
    runtime = "nodejs18.x"
    role=module.myrole.arns[0]
    
}




resource "aws_instance" "ec2_user" {
    instance_type = "t2.micro"
    associate_public_ip_address = true
    ami= var.ami_id


    tags={
        Name= "ec2_user"
    }
  
}