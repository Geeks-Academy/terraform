### ECS SERVICES

data "template_file" "auth" {
  template = file("ProgrammersOnly/task_definitions/auth_task_definition.json")
}

resource "aws_ecs_task_definition" "auth" {
  family                = "auth"
  container_definitions = file("ProgrammersOnly/task_definitions/auth_task_definition.json")
}

data "aws_ecs_task_definition" "auth" {
  task_definition = aws_ecs_task_definition.auth.family
  depends_on      = [aws_ecs_task_definition.auth]
}

resource "aws_ecr_repository" "auth" {
  name = "auth"
}

resource "aws_ecr_repository_policy" "auth" {
  repository = aws_ecr_repository.auth.name

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "auth_ECR",
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

resource "aws_ecs_service" "auth" {
  name                               = "auth"
  cluster                            = aws_ecs_cluster.programmers_only.id
  task_definition                    = "auth:${data.aws_ecs_task_definition.auth.revision}"
  desired_count                      = 1
  deployment_minimum_healthy_percent = 0
}
