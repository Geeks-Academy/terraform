### ECS SERVICES

data "template_file" "mongodb" {
  template = file("ProgrammersOnly/task_definitions/mongodb_task_definition.json")
}

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
        "ssm:GetParameters",
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

resource "aws_ecs_task_definition" "mongodb" {
  family                = "mongodb"
  container_definitions = file("ProgrammersOnly/task_definitions/mongodb_task_definition.json")
  task_role_arn         = aws_iam_role.ecs_role.arn
}

data "aws_ecs_task_definition" "mongodb" {
  task_definition = aws_ecs_task_definition.mongodb.family
  depends_on      = [aws_ecs_task_definition.mongodb]
}

resource "aws_ecr_repository" "mongodb" {
  name = "mongodb"
}

resource "aws_ecr_repository_policy" "mongodb" {
  repository = aws_ecr_repository.mongodb.name

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "MONGODB_ECR",
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

resource "aws_ecs_service" "mongodb" {
  name                               = "mongodb"
  cluster                            = aws_ecs_cluster.programmers_only.id
  task_definition                    = "mongodb:${data.aws_ecs_task_definition.mongodb.revision}"
  desired_count                      = 1
  deployment_minimum_healthy_percent = 0
}
