locals {
  tags = merge(
    map(
      "Layer", "ECS",
    ),
    var.tags
  )
}
