resource "aws_lambda_function" "update_route53" {
  filename      = "update_route53.zip"
  function_name = "update_route53"
  role          = var.iam_for_lambda_arn
  handler       = "update_route53.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("update_route53.zip"))}"
  source_code_hash = filebase64sha256("update_route53.zip")

  runtime = "python3.6"

  environment {
    variables = {
      foo = "bar"
    }
  }
}

output "update_route53_arn" {
  value = aws_lambda_function.update_route53.arn
}