resource "aws_iam_instance_profile" "ec2" {
  name = "ecs_ec2_profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name = "ecs_ec2_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_policy" "policy" {
  name        = "ECS_EC2"
  description = ""
  policy      = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "ecs:*",
              "ecr:*",
              "kms:*",
              "s3:GetObject",
              "s3:GetBucketLocation"
            ],
            "Resource": "*"
        }
    ]
}
  POLICY
}

resource "aws_iam_policy_attachment" "ec2toecs" {
  name       = "ECS_EC2"
  roles      = [aws_iam_role.role.name]
  policy_arn = aws_iam_policy.policy.arn
}

output "instance_profile_ec2" {
  value = aws_iam_instance_profile.ec2.name
}
