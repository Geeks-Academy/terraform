### ECS SERVICES
resource "aws_ecs_task_definition" "mongodb" {
  family                = "mongodb"
  container_definitions = file("ProgrammersOnly/task_definitions/mongodb_task_definition.json")
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
  task_definition                    = aws_ecs_task_definition.mongodb.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 0

  load_balancer {
    target_group_arn = aws_alb_target_group.mongodb.arn
    container_name   = "mongodb"
    container_port   = 27017
  }
}

resource "aws_alb_target_group" "mongodb" {
  name_prefix = "po-"
  port        = 27017
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
