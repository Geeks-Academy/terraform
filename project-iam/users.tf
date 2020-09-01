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
