resource "aws_iam_role" "asg_manager" {
  name = "asg_manager"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_policy" "asg_manager" {
  name        = "asg_manager"
  description = ""
  policy      = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowManageASG",
            "Effect": "Allow",
            "Action": [
                "autoscaling:*"
            ],
            "Resource": "*"
        }
    ]
}
  POLICY
}

resource "aws_iam_policy_attachment" "asg_manager" {
  name       = "asg_manager"
  roles      = [aws_iam_role.asg_manager.name]
  policy_arn = aws_iam_policy.asg_manager.arn
}

output "asg_manager_lambda_arn" {
  value = aws_iam_role.asg_manager.arn
}
