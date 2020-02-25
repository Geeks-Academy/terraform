locals {
  tags = merge(
    map(
      "Layer", "EC2",
    ),
    var.tags
  )
}
