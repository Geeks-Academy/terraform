locals {
  mongo_env_file  = "env_files/mongo.env",
  artifact_bucket = "programmers_only_artifacts" 
}

data "template_file" "mongodb" {
  template = "${file("ProgrammersOnly/task_definitions/mongodb_task_definition.json")}"
}

resource "aws_ecs_task_definition" "mongodb" {
  family                = "mongodb"
  container_definitions = file("ProgrammersOnly/task_definitions/mongodb_task_definition.json")
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
                "ecr:DeleteRepositoryPolicy",
                "s3:GetObject",
                "s3:GetBucketLocation",
                "kms:*"
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

resource "aws_s3_bucket_object" "mongo_env_file" {
  key    = local.mongo_env_file
  bucket = local.artifact_bucket
  source = local.mongo_env_file
  
  force_destroy = true
}