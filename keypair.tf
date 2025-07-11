resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "Wordpress_KEY" {
  key_name   = "wordpress_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "privatepem_file" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "wordpress_key.pem"
}