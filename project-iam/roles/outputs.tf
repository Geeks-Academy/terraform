output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.ec2.name
}

output "force_mfa_policy_arn" {
  value = aws_iam_policy.force_mfa.arn
}

output "iam_update_route53_arn" {
  value = aws_iam_role.update_route53.arn
}