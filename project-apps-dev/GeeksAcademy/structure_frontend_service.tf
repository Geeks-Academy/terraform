### ECS SERVICES

data "template_file" "structure_frontend" {
  template = file("GeeksAcademy/task_definitions/task_definition_sample.json")
  vars = {
    service_name   = "structure_frontend"
    container_port = 3000
  }
}

resource "aws_ecs_task_definition" "structure_frontend" {
  family                = "structure_frontend"
  container_definitions = data.template_file.structure_frontend.rendered
}

data "aws_ecs_task_definition" "structure_frontend" {
  task_definition = aws_ecs_task_definition.structure_frontend.family
  depends_on      = [aws_ecs_task_definition.structure_frontend]
}

resource "aws_ecr_repository" "structure_frontend" {
  name = "structure_frontend"
}

resource "aws_ecr_repository_policy" "structure_frontend" {
  repository = aws_ecr_repository.structure_frontend.name

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "structure_frontend_ECR",
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

resource "aws_ecs_service" "structure_frontend" {
  name                               = "structure_frontend"
  cluster                            = aws_ecs_cluster.geeks_academy.id
  task_definition                    = "structure_frontend:${data.aws_ecs_task_definition.structure_frontend.revision}"
  desired_count                      = 1
  deployment_minimum_healthy_percent = 0

  load_balancer {
    target_group_arn = aws_alb_target_group.structure_frontend.arn
    container_name   = "structure_frontend"
    container_port   = 3000
  }
}

resource "aws_alb_target_group" "structure_frontend" {
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
