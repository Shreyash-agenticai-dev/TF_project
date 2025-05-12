output "public_ec2_ip" {
  value = aws_instance.public_ec2_instance.public_ip
}

output "private_ec2_ip" {
  value = aws_instance.private_ec2_instance.private_ip
}