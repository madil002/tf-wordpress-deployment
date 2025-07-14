resource "aws_instance" "wordpress_instance" {
  ami                         = "ami-044415bb13eee2391"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.Wordpress_subnet_1.id
  vpc_security_group_ids      = [aws_security_group.Wordpress_SG.id]
  key_name                    = aws_key_pair.Wordpress_KEY.key_name
  associate_public_ip_address = true

  tags = {
    Name = "Ec2"
  }
  user_data = file("${path.module}/script.sh")
}