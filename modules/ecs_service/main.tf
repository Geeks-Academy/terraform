data "template_file" "service" {
  template = file("ProgrammersOnly/task_definitions/service_task_definition.json")
}

resource "aws_ecs_task_definition" "service" {
  family                = "service"
  container_definitions = file("ProgrammersOnly/task_definitions/service_task_definition.json")
  task_role_arn         = aws_iam_role.ecs_role.arn
  execution_role_arn    = aws_iam_role.ecs_role.arn
}

data "aws_ecs_task_definition" "service" {
  task_definition = aws_ecs_task_definition.service.family
  depends_on      = [aws_ecs_task_definition.service]
}

resource "aws_ecr_repository" "service" {
  name = "service"
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
  name                               = "service"
  cluster                            = aws_ecs_cluster.programmers_only.id
  task_definition                    = "service:${data.aws_ecs_task_definition.service.revision}"
  desired_count                      = 1
  deployment_minimum_healthy_percent = 0

  load_balancer {
    target_group_arn = aws_alb_target_group.service.arn
    container_name   = "service"
    container_port   = 3000
  }
}

resource "aws_alb_target_group" "service" {
  name_prefix = "po-"
  port        = 3000
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