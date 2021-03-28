### ECS SERVICES

data "template_file" "structure_backend" {
  template = file("GeeksAcademy/task_definitions/task_definition_sample.json")
  vars = {
    service_name   = "structure_backend"
    container_port = 3000
  }
}

resource "aws_ecs_task_definition" "structure_backend" {
  family                = "structure_backend"
  container_definitions = data.template_file.structure_backend.rendered
}

data "aws_ecs_task_definition" "structure_backend" {
  task_definition = aws_ecs_task_definition.structure_backend.family
  depends_on      = [aws_ecs_task_definition.structure_backend]
}

resource "aws_ecr_repository" "structure_backend" {
  name = "structure_backend"
}

resource "aws_ecr_repository_policy" "structure_backend" {
  repository = aws_ecr_repository.structure_backend.name

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "structure_backend_ECR",
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

resource "aws_ecs_service" "structure_backend" {
  name                               = "structure_backend"
  cluster                            = aws_ecs_cluster.geeks_academy.id
  task_definition                    = "structure_backend:${data.aws_ecs_task_definition.structure_backend.revision}"
  desired_count                      = 1
  deployment_minimum_healthy_percent = 0

  load_balancer {
    target_group_arn = aws_alb_target_group.structure_backend.arn
    container_name   = "structure_backend"
    container_port   = 4000
  }
}

resource "aws_alb_target_group" "structure_backend" {
  name_prefix = "po-"
  port        = 4000
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
