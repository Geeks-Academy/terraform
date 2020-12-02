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

  private_dns_entries = {
    "1" = "www.programmers.only"
    "2" = "auth.programmers.only"
  }
}
