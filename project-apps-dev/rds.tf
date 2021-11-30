# data "aws_ssm_parameter" "username" {
#   name = "/geeksacademy/postgresql/username"
# }

# data "aws_ssm_parameter" "password" {
#   name = "/geeksacademy/postgresql/password"
# }

# resource "aws_db_subnet_group" "postgresql" {
#   name       = "postgresql12.4"
#   subnet_ids = data.terraform_remote_state.project-core.outputs.public_subnets

#   tags = {
#     "Name"       = "postgresql12.4",
#     "Managed by" = "Terraform"
#   }
# }

# resource "aws_db_instance" "geeks_academy" {
#   identifier             = "geeks-academy-dev"
#   allocated_storage      = 20
#   storage_type           = "gp2"
#   engine                 = "postgres"
#   engine_version         = "12.4"
#   instance_class         = "db.t2.micro"
#   name                   = "dev"
#   username               = data.aws_ssm_parameter.username.value
#   password               = data.aws_ssm_parameter.password.value
#   db_subnet_group_name   = aws_db_subnet_group.postgresql.id
#   publicly_accessible    = true
#   vpc_security_group_ids = [module.sg.rds_sg_id]
#   skip_final_snapshot    = true

#   lifecycle {
#     ignore_changes = [
#       engine_version
#     ]
#   }

# }
