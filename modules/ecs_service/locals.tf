locals {
    geeks_cluster_arn = "arn:aws:ecs:${var.region}:${var.account_number}:cluster/GeeksAcademy"
    task_role_arn = "arn:aws:iam::${var.account_number}:role/${var.ecs_role_name}"
}