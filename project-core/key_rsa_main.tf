resource "tls_private_key" "rsa_main" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "deployer" {
  key_name   = "devopskey"
  public_key = tls_private_key.rsa_main.public_key_openssh
}

output "rsa_main_private_pem" {
  value = tls_private_key.rsa_main.private_key_pem
}
