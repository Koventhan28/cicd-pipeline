output "instance_public_ip" {
  value = aws_instance.ec2_dev.public_dns
}