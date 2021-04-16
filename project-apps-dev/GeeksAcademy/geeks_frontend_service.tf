### ECS SERVICES

data "template_file" "geeks_frontend" {
  template = file("GeeksAcademy/task_definitions/geeks_frontend_task_definition.json")
}

resource "aws_ecs_task_definition" "geeks_frontend" {
  family                = "geeks_frontend"
  container_definitions = file("GeeksAcademy/task_definitions/geeks_frontend_task_definition.json")
}

data "aws_ecs_task_definition" "geeks_frontend" {
  task_definition = aws_ecs_task_definition.geeks_frontend.family
  depends_on      = [aws_ecs_task_definition.geeks_frontend]
}

resource "aws_ecr_repository" "geeks_frontend" {
  name = "geeks_frontend"
}

resource "aws_ecr_repository_policy" "geeks_frontend" {
  repository = aws_ecr_repository.geeks_frontend.name

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "geeks_frontend_ECR",
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

resource "aws_ecr_lifecycle_policy" "geeks_frontend" {
  repository = aws_ecr_repository.geeks_frontend.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 5 images",
            "selection": {
                "countType": "imageCountMoreThan",
                "countNumber": 5
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}


resource "aws_ecs_service" "geeks_frontend" {
  name                               = "geeks_frontend"
  cluster                            = aws_ecs_cluster.geeks_academy.id
  task_definition                    = "geeks_frontend:${data.aws_ecs_task_definition.geeks_frontend.revision}"
  desired_count                      = 1
  deployment_minimum_healthy_percent = 0

  load_balancer {
    target_group_arn = aws_alb_target_group.geeks_frontend.arn
    container_name   = "geeks_frontend"
    container_port   = 80
  }
}

resource "aws_alb_target_group" "geeks_frontend" {
  name_prefix = "po-"
  port        = 80
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
