locals {
  tags = merge(
    map(
      "Layer", "ECS",
      "Name", "ProgrammersOnly",
      "Managed by", "terraform",
      "EnvironmentType", "dev",
    ),
    var.tags
  )
}
