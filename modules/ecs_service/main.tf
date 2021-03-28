resource "aws_ecr_repository" "service" {
  name = var.service_name
}

resource "aws_ecr_repository_policy" "service" {
  repository = aws_ecr_repository.service.name

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "service_ECR",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
        }
    ]
}
EOF
}

resource "aws_ecs_service" "service" {
  name                               = var.service_name
  cluster                            = local.geeks_cluster_arn
  task_definition                    = "${var.task_definition_arn}"
  desired_count                      = var.desired_count
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  load_balancer {
    target_group_arn = aws_alb_target_group.service.arn
    container_name   = var.service_name
    container_port   = var.container_port
  }
}

resource "aws_alb_target_group" "service" {
  name_prefix = var.name_prefix
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    path     = "/"
    port     = "traffic-port"
    interval = 300
    matcher  = "200-499"
  }

  tags = var.tags
}