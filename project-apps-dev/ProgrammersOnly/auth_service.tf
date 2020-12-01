### ECS SERVICES

data "template_file" "auth" {
  template = file("ProgrammersOnly/task_definitions/auth_task_definition.json")
}

resource "aws_ecs_task_definition" "auth" {
  family                = "auth"
  container_definitions = file("ProgrammersOnly/task_definitions/auth_task_definition.json")
  task_role_arn         = aws_iam_role.ecs_role.arn
  execution_role_arn    = aws_iam_role.ecs_role.arn
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

  load_balancer {
    target_group_arn = aws_alb_target_group.auth.arn
    container_name   = "auth"
    container_port   = 3000
  }
}

resource "aws_alb_target_group" "auth" {
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

### ENV PASSING

resource "aws_iam_role" "ecs_role" {
  name               = "ecs_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name     = "ecs_service_role_policy"
  role     = aws_iam_role.ecs_role.id
  policy   = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:*",
        "ssm:GetParameters",
        "ssm:GetParameter",
        "ssm:DescribeParameters",
        "secretsmanager:GetSecretValue"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}
