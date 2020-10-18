resource "aws_lambda_function" "update_private_route53" {
  filename      = "update_private_route53.zip"
  function_name = "update_private_route53"
  role          = var.iam_for_lambda_arn
  handler       = "update_private_route53.lambda_handler"
  timeout       = 9

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("update_private_route53.zip"))}"
  source_code_hash = filebase64sha256("update_private_route53.zip")

  runtime = "python3.6"

  environment {
    variables = {
      HOSTED_ZONE_ID = "${var.private_zone_id}"
    }
  }

  lifecycle {
    ignore_changes = [
      last_modified
    ]
  }
}

resource "aws_lambda_permission" "update_private_route53" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_private_route53.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.discover_services.arn
}

resource "aws_sns_topic" "discover_services" {
  name = "discover_services"
}

resource "aws_sns_topic_subscription" "discover_services_sqs_target" {
  topic_arn = aws_sns_topic.discover_services.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.update_private_route53.arn
}

output "service_discovery_sns_topic_arn" {
  value = aws_sns_topic.discover_services.arn
}
