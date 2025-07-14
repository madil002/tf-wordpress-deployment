output "instance_ip" {
  value = aws_instance.wordpress_instance.public_ip
}