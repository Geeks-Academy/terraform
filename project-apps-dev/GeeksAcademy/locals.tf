locals {
  tags = merge(
    tomap({
      "Layer" = "ECS",
      "Name" = "geeks-academy",
      "Managed by" = "terraform",
      "EnvironmentType" = "dev",
    }),
    var.tags
  )
}
