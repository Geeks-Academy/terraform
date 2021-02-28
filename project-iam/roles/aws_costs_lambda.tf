resource "aws_iam_role" "aws_costs" {
  name = "aws_costs"
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

resource "aws_iam_policy" "aws_costs" {
  name        = "aws_costs"
  description = ""
  policy      = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowCosts",
            "Effect": "Allow",
            "Action": [
                "cur:*",
                "ce:*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowKMS",
            "Effect": "Allow",
            "Action": [
                "kms:*"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowSSM",
            "Effect": "Allow",
            "Action": [
                "ssm:*"
            ],
            "Resource": "arn:aws:ssm:*:*:parameter/programmersonly/devops/*"
        }
    ]
}
  POLICY
}

resource "aws_iam_policy_attachment" "aws_costs" {
  name       = "aws_costs"
  roles      = [aws_iam_role.aws_costs.name]
  policy_arn = aws_iam_policy.aws_costs.arn
}

output "aws_costs_lambda_arn" {
  value = aws_iam_role.aws_costs.arn
}
