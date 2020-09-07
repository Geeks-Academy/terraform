### ECS SERVICES

data "template_file" "frontend" {
  template = "${file("ProgrammersOnly/task_definitions/frontend_task_definition.json")}"
}

resource "aws_ecs_task_definition" "frontend" {
  family                = "frontend"
  container_definitions = file("ProgrammersOnly/task_definitions/frontend_task_definition.json")
}

data "aws_ecs_task_definition" "frontend" {
  task_definition = aws_ecs_task_definition.frontend.family
  depends_on      = [aws_ecs_task_definition.frontend]
}

resource "aws_ecr_repository" "frontend" {
  name = "frontend"
}

resource "aws_ecr_repository_policy" "frontend" {
  repository = aws_ecr_repository.frontend.name

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "FRONTEND_ECR",
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

resource "aws_ecs_service" "frontend" {
  name                               = "frontend"
  cluster                            = aws_ecs_cluster.programmers_only.id
  task_definition                    = "frontend:${data.aws_ecs_task_definition.frontend.revision}"
  desired_count                      = 1
  deployment_minimum_healthy_percent = 0
}
