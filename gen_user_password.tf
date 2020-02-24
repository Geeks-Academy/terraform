resource "random_pet" "user" {
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "local_file" "user" {
  content  = random_password.password.result
  filename = "${path.module}/${random_pet.user.id}.txt"
}
