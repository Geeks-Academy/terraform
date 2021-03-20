locals {
  tags = merge(
    map(
      "Layer", "ECS",
      "Name", "geeks-academy",
      "Managed by", "terraform",
      "EnvironmentType", "dev",
    ),
    var.tags
  )
}
