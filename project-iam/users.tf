### USERS

module "Piotr" {
  source = "../modules/user"

  username               = "Piotr"
  group_membership       = "administrator"
  policy_attachement_arn = module.roles.force_mfa_policy_arn
  console_access         = true
}

module "ECS_Deployer" {
  source = "../modules/user"

  username            = "ecs_deployer"
  group_membership    = "deployer"
  programmatic_access = true
}

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
              "ecr:*",
              "iam:PassRole",
              "sns:List*",
              "s3:*"
            ],
            "Resource": "*"
        }
    ]
}
  POLICY
}
