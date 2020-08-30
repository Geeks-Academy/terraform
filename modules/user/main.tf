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
  policy_arn = aws_iam_policy.force_mfa.arn
}

resource "aws_iam_user_group_membership" "group_membership" {
  user = aws_iam_user.user.name

  groups = [
    var.group_membership,
  ]
}

resource "aws_iam_policy" "force_mfa" {
  name   = "Force_MFA"
  path   = "/"
  policy = var.allow_password_change_without_mfa ? data.aws_iam_policy_document.force_mfa_but_allow_sign_in_to_change_password.json : data.aws_iam_policy_document.force_mfa.json
}

output "password" {
  value = aws_iam_user_login_profile.user.encrypted_password
}