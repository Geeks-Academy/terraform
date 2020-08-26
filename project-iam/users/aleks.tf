### TODO create user for Aleks
resource "aws_iam_user" "aleks" {
  name          = "Aleks"
  path          = "/"
  force_destroy = true
}

resource "aws_iam_user_login_profile" "aleks" {
  user    = aws_iam_user.example.name
  pgp_key = "keybase:terraform"
}

output "password" {
  value = aws_iam_user_login_profile.aleks.encrypted_password
}