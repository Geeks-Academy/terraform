### ECS SERVICES

data "template_file" "nginx" {
  template = "${file("ProgrammersOnly/task_definitions/nginx_task_definition.json")}"
}

resource "aws_ecs_task_definition" "nginx" {
  family                = "nginx"
  network_mode          = "awsvpc"
  container_definitions = file("ProgrammersOnly/task_definitions/nginx_task_definition.json")
}

data "aws_ecs_task_definition" "nginx" {
  task_definition = aws_ecs_task_definition.nginx.family
  depends_on      = [aws_ecs_task_definition.nginx]
}

resource "aws_ecr_repository" "nginx" {
  name = "nginx"
}

resource "aws_ecr_repository_policy" "nginx" {
  repository = aws_ecr_repository.nginx.name

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "NGINX_ECR",
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

resource "aws_service_discovery_service" "nginx" {
  name = "nginx"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.programmers_only.id

    dns_records {
      ttl  = 60
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 3
  }
}

resource "aws_ecs_service" "nginx" {
  name                               = "nginx"
  cluster                            = aws_ecs_cluster.programmers_only.id
  task_definition                    = "nginx:${data.aws_ecs_task_definition.nginx.revision}"
  desired_count                      = 1
  deployment_minimum_healthy_percent = 0

  service_registries {
    registry_arn   = aws_service_discovery_service.nginx.arn
    container_name = "nginx"
  }

  network_configuration {
    subnets = var.subnets
    security_groups = var.security_groups
  }
}
