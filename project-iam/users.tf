### USERS

module "Piotr" {
  source = "../modules/user"

  username               = "Piotr"
  group_membership       = "administrator"
  policy_attachement_arn = module.roles.force_mfa_policy_arn
  console_access         = true
}

# module "Marek" {
#   source = "../modules/user"

#   username               = "Marek"
#   group_membership       = "developer"
#   policy_attachement_arn = module.roles.force_mfa_policy_arn
#   console_access         = true
# }

module "ECS_Deployer" {
  source = "../modules/user"

  username            = "ecs_deployer"
  group_membership    = "deployer"
  programmatic_access = true
}
