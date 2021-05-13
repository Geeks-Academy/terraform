resource "aws_iam_user" "user" {
  name          = var.username
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "user" {
  count   = var.console_access ? 1 : 0
  user    = aws_iam_user.user.name
  pgp_key = "keybase:terraform"
}

resource "aws_iam_access_key" "user" {
  count = var.programmatic_access ? 1 : 0
  user = aws_iam_user.user.name
}

resource "aws_iam_user_policy_attachment" "assign_force_mfa_policy_to_users" {
  count      = var.policy_attachement_arn == "" ? 0 : 1
  user       = aws_iam_user.user.name
  policy_arn = var.policy_attachement_arn
}

resource "aws_iam_user_group_membership" "group_membership" {
  user = aws_iam_user.user.name

  groups = var.group_membership
}
