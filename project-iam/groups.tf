### GROUPS

#ADMINISTRATOR
resource "aws_iam_group" "administrator" {
  name = "administrator"
}

resource "aws_iam_group_policy_attachment" "attachment" {
  group      = aws_iam_group.administrator.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

#DEPLOYER
resource "aws_iam_group" "deployer" {
  name = "deployer"
}

resource "aws_iam_group_policy_attachment" "deployer_attachment" {
  group      = aws_iam_group.deployer.name
  policy_arn = aws_iam_policy.deployer_policy.arn
}

resource "aws_iam_policy" "deployer_policy" {
  name        = "ECS_Deployer"
  description = ""
  policy      = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "ecs:*",
              "elasticloadbalancing:AddTags",
              "elasticloadbalancing:CreateTargetGroup",
              "elasticloadbalancing:DeleteTargetGroup",
              "elasticloadbalancing:Describe*",
              "elasticloadbalancing:Modify*",
              "ecr:*",
              "iam:PassRole",
              "sns:List*",
              "s3:Get*",
              "s3:List*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
              "s3:*"
            ],
            "Resource": [
              "arn:aws:s3:::statestf/states/apps/dev/*",
              "arn:aws:s3:::structure.geeks.academy/*"
            ]
        }
    ]
}
  POLICY
}

#DEVELOPER
resource "aws_iam_group" "developer" {
  name = "developer"
}

resource "aws_iam_group_policy_attachment" "developer_attachment" {
  group      = aws_iam_group.developer.name
  policy_arn = aws_iam_policy.developer_policy.arn
}

resource "aws_iam_policy" "developer_policy" {
  name        = "Developer"
  description = ""
  policy      = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "logs:*"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        }
    ]
}
  POLICY
}
