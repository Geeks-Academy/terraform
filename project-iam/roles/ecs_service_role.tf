resource "aws_iam_role" "ecs_role" {
  name               = "ecs_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name     = "ecs_service_role_policy"
  role     = aws_iam_role.ecs_role.id
  policy   = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:*",
        "ssm:GetParameters",
        "ssm:GetParameter",
        "ssm:DescribeParameters",
        "secretsmanager:GetSecretValue"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}
