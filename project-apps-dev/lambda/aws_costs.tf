resource "aws_lambda_function" "aws_costs" {
  filename      = "aws_costs.zip"
  function_name = "aws_costs"
  role          = var.iam_for_aws_costs_lambda_arn
  handler       = "aws_costs.lambda_handler"
  timeout       = 90

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("aws_costs.zip"))}"
  source_code_hash = filebase64sha256("aws_costs.zip")

  runtime = "python3.7"

  environment {
    variables = {
      SLACKWEBHOOK = "/programmersonly/devops/slackwebhook"
    }
  }

  lifecycle {
    ignore_changes = [
      last_modified
    ]
  }
}

resource "aws_lambda_permission" "aws_costs_daily" {
  statement_id  = "AllowExecutionFromCWDaily"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.aws_costs.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.daily_event_rule.arn
}

resource "aws_cloudwatch_event_rule" "daily_event_rule" {
  name = "daily_event_rule"
  schedule_expression = "cron(0 9 * * ? *)"
}

resource "aws_cloudwatch_event_target" "check_at_rate_daily" {
  rule = aws_cloudwatch_event_rule.daily_event_rule.name
  arn = aws_lambda_function.aws_costs.arn

  input = "{\"type\":\"DAILY\"}"
}

resource "aws_lambda_permission" "aws_costs_monthly" {
  statement_id  = "AllowExecutionFromCWMonthly"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.aws_costs.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.monthly_event_rule.arn
}

resource "aws_cloudwatch_event_rule" "monthly_event_rule" {
  name = "monthly_event_rule"
  schedule_expression = "cron(0 13 4 * ? *)"
}

resource "aws_cloudwatch_event_target" "check_at_rate_monthly" {
  rule = aws_cloudwatch_event_rule.monthly_event_rule.name
  arn = aws_lambda_function.aws_costs.arn

  input = "{\"type\":\"MONTHLY\"}"
}