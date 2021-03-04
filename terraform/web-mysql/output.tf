output "webserver-ip" {
  value = aws_instance.web.public_ip
}
output "mysql-ip" {
  value = aws_instance.mysql.public_ip
}
output "webserver-id" {
  value = aws_instance.web.id
}
output "mysql-id" {
  value = aws_instance.mysql.id
}