output "instance_profile_ec2" {
  value = module.roles.ec2_instance_profile_name
}

output "iam_update_route53_arn" {
  value = module.roles.iam_update_route53_arn
}

output "allow_posting_to_sns_arn" {
  value = module.roles.allow_posting_to_sns_arn
}
