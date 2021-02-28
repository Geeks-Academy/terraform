resource "aws_lambda_function" "asg_manager" {
  filename      = "asg_manager.zip"
  function_name = "asg_manager"
  role          = var.iam_for_asg_manager_lambda_arn
  handler       = "asg_manager.lambda_handler"
  timeout       = 90

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("asg_manager.zip"))}"
  source_code_hash = filebase64sha256("asg_manager.zip")

  runtime = "python3.7"

  lifecycle {
    ignore_changes = [
      last_modified
    ]
  }
}

resource "aws_lambda_permission" "asg_manager_up" {
  statement_id  = "AllowExecutionFromCWup"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.asg_manager.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.up_event_rule.arn
}

resource "aws_cloudwatch_event_rule" "up_event_rule" {
  name = "up_event_rule"
  schedule_expression = "cron(0 5 * * ? *)"
}

resource "aws_cloudwatch_event_target" "check_at_rate_up" {
  rule = aws_cloudwatch_event_rule.up_event_rule.name
  arn = aws_lambda_function.asg_manager.arn

  input = "{\"type\":\"UP\"}"
}

resource "aws_lambda_permission" "asg_manager_down" {
  statement_id  = "AllowExecutionFromCWdown"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.asg_manager.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.down_event_rule.arn
}

resource "aws_cloudwatch_event_rule" "down_event_rule" {
  name = "down_event_rule"
  schedule_expression = "cron(0 1 * * ? *)"
}

resource "aws_cloudwatch_event_target" "check_at_rate_down" {
  rule = aws_cloudwatch_event_rule.down_event_rule.name
  arn = aws_lambda_function.asg_manager.arn

  input = "{\"type\":\"DOWN\"}"
}