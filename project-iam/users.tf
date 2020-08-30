### USERS

module "Damklis" {
  source = "../modules/user"

  username         = "Damklis"
  group_membership = "administrator"
}

module "Kuba" {
  source = "../modules/user"

  username         = "Kuba"
  group_membership = "administrator"
}

module "Aleks_J" {
  source = "../modules/user"

  username         = "AleksJ"
  group_membership = "administrator"
}

### GROUPS

resource "aws_iam_group" "administrator" {
  name = "administrator"
}

resource "aws_iam_group_policy_attachment" "test-attach" {
  group      = aws_iam_group.group.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
