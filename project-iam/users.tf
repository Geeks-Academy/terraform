### USERS

module "Damklis" {
  source = "../modules/user"

  username         = "Damklis"
  group_membership = "administrator"
  force_mfa_policy_arn = module.roles.force_mfa_policy_arn
}

module "Kuba" {
  source = "../modules/user"

  username         = "Kuba"
  group_membership = "administrator"
  force_mfa_policy_arn = module.roles.force_mfa_policy_arn
}

module "Aleks_J" {
  source = "../modules/user"

  username         = "AleksJ"
  group_membership = "administrator"
  force_mfa_policy_arn = module.roles.force_mfa_policy_arn
}

### GROUPS

resource "aws_iam_group" "administrator" {
  name = "administrator"
}

resource "aws_iam_group_policy_attachment" "attachment" {
  group      = aws_iam_group.administrator.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

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
              "ecr:*"
            ],
            "Resource": "*"
        }
    ]
}
  POLICY
}
