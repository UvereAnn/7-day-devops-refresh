output "instance_id" { value = aws_instance.web.id }
output "public_ip" { value = aws_instance.web.public_ip }
output "ssh_command" {
  value = "ssh -i /PATH/TO/PRIVATE_KEY.pem ubuntu@${aws_instance.web.public_ip}"
}
