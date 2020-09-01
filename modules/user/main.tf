resource "aws_iam_user" "user" {
  name          = var.username
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "user" {
  user    = aws_iam_user.user.name
  pgp_key = "keybase:terraform"
}

resource "aws_iam_user_policy_attachment" "assign_force_mfa_policy_to_users" {
  user       = aws_iam_user.user.name
  policy_arn = var.force_mfa_policy_arn
}

resource "aws_iam_user_group_membership" "group_membership" {
  user = aws_iam_user.user.name

  groups = [
    var.group_membership,
  ]
}

output "password" {
  value = aws_iam_user_login_profile.user.encrypted_password
}